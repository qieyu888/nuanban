#!/usr/bin/env bash
# Build Flutter iOS xcframeworks for host-app embedding + App Store (ITMS-91065).
# - Flutter.xcframework: keep official Flutter signature
# - App + plugins: inside-out codesign with Apple Distribution
#   (nested *.bundle -> *.framework slices -> *.xcframework)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

OUTPUT_DIR="build/ios-framework"
RELEASE_DIR="$OUTPUT_DIR/Release"
SIGN_ID="${IOS_CODESIGN_IDENTITY:-Apple Distribution: Jiuming Zhang (FZLGG2K455)}"

echo "==> Using identity: $SIGN_ID"
security find-identity -v -p codesigning | grep -F "$SIGN_ID" >/dev/null \
  || { echo "ERROR: codesigning identity not found in keychain: $SIGN_ID"; exit 1; }

echo "==> flutter pub get"
flutter pub get

echo "==> flutter build ios-framework (Release only)"
rm -rf "$RELEASE_DIR"
flutter build ios-framework \
  --release \
  --no-debug \
  --no-profile \
  --obfuscate \
  --split-debug-info=./symbols \
  --no-tree-shake-icons \
  --output="$OUTPUT_DIR"

# App Store rejects App.framework when MinimumOSVersion is missing/empty.
MIN_OS="$(/usr/libexec/PlistBuddy -c 'Print :MinimumOSVersion' ios/Flutter/AppFrameworkInfo.plist 2>/dev/null || echo '13.0')"
echo "==> Ensure App.framework MinimumOSVersion=${MIN_OS}"
while IFS= read -r plist; do
  /usr/libexec/PlistBuddy -c "Set :MinimumOSVersion ${MIN_OS}" "$plist" 2>/dev/null \
    || /usr/libexec/PlistBuddy -c "Add :MinimumOSVersion string ${MIN_OS}" "$plist"
  echo "  patched: $plist"
done < <(find "$RELEASE_DIR/App.xcframework" -name Info.plist -path '*/App.framework/*')

sign_item() {
  local path="$1"
  echo "  codesign: $path"
  # No --options runtime: that flag is for apps; frameworks should use plain Distribution sign.
  codesign --force --sign "$SIGN_ID" --timestamp --generate-entitlement-der "$path"
  codesign --verify --strict "$path"
}

echo "==> Codesign frameworks inside-out (fix ITMS-91065 Missing signature)"
for xc in "$RELEASE_DIR"/*.xcframework; do
  name="$(basename "$xc" .xcframework)"
  if [[ "$name" == "Flutter" ]]; then
    echo "  skip official Flutter.xcframework"
    continue
  fi

  echo "==> $name"
  # 1) Nested resource bundles first
  while IFS= read -r bundle; do
    sign_item "$bundle"
  done < <(find "$xc" -name '*.bundle' -type d)

  # 2) Every .framework slice (device + simulator)
  while IFS= read -r fw; do
    binary="$fw/$(basename "$fw" .framework)"
    if [[ -f "$binary" ]] && file "$binary" | grep -q "current ar archive"; then
      echo "  skip static framework binary: $(basename "$fw")"
      # Still sign the bundle wrapper if it has dynamic content? Static archives
      # are linked into the host and usually not embedded — skip.
      continue
    fi
    sign_item "$fw"
  done < <(find "$xc" -name '*.framework' -type d | awk '{ print length, $0 }' | sort -nr | cut -d' ' -f2-)

  # 3) XCFramework wrapper itself (Apple verifies XCFramework origin)
  sign_item "$xc"
done

echo "==> Verify Headers/Modules + signatures"
fail=0
for xc in "$RELEASE_DIR"/*.xcframework; do
  name="$(basename "$xc" .xcframework)"
  device_fw="$(find "$xc" -path '*ios-arm64/*.framework' ! -path '*simulator*' -type d | head -1)"
  [[ -z "$device_fw" ]] && continue

  echo "--- $name ---"
  if [[ "$name" == "App" ]]; then
    min_os="$(/usr/libexec/PlistBuddy -c 'Print :MinimumOSVersion' "$device_fw/Info.plist" 2>/dev/null || true)"
    if [[ -z "$min_os" ]]; then
      echo "ERROR: App.framework Missing MinimumOSVersion"
      fail=1
    else
      echo "MinimumOSVersion: $min_os"
    fi
  elif [[ "$name" != "Flutter" && "$name" != "flutter_tts" ]]; then
    if [[ ! -f "$device_fw/Modules/module.modulemap" ]]; then
      echo "ERROR: missing Modules/module.modulemap"
      fail=1
    else
      echo "modulemap: OK"
    fi
    if [[ ! -d "$device_fw/Headers" ]]; then
      echo "ERROR: missing Headers/"
      fail=1
    else
      echo "headers: OK ($(ls "$device_fw/Headers" | wc -l | tr -d ' ') files)"
    fi
  fi

  if [[ "$name" == "Flutter" ]]; then
    codesign -dvv "$device_fw" 2>&1 | grep -E "Authority=|TeamIdentifier=" || true
    continue
  fi

  if [[ "$name" == "flutter_tts" ]]; then
    echo "static plugin (not embedded as dynamic SDK)"
    continue
  fi

  if ! codesign --verify --strict "$device_fw" 2>/dev/null; then
    echo "ERROR: codesign verify failed for $device_fw"
    fail=1
  fi
  if [[ ! -d "$device_fw/_CodeSignature" ]]; then
    echo "ERROR: missing _CodeSignature for $device_fw"
    fail=1
  else
    echo "_CodeSignature: OK"
  fi
  codesign -dvv "$device_fw" 2>&1 | grep -E "Authority=|TeamIdentifier=" || true
  codesign --verify --strict "$xc" 2>/dev/null && echo "xcframework signature: OK" || echo "WARN: xcframework verify failed"
done

if [[ "$fail" -ne 0 ]]; then
  echo "ERROR: framework packaging incomplete"
  exit 1
fi

echo "==> flutter build ipa (App Store)"
rm -rf build/ios/archive build/ios/ipa
flutter build ipa \
  --release \
  --obfuscate \
  --split-debug-info=./symbols \
  --export-options-plist=ExportOptions.plist \
  --no-tree-shake-icons

VERSION="$(grep '^version:' pubspec.yaml | awk '{print $2}')"
ZIP="build/nuanban-ios-framework-signed-${VERSION}.zip"
rm -f "$ZIP"
echo "==> Create $ZIP"
(
  cd "$OUTPUT_DIR"
  zip -r "../$(basename "$ZIP")" Release GeneratedPluginRegistrant.h GeneratedPluginRegistrant.m
)

# Optional host sync
HOST_DIR="${HOST_FRAMEWORK_DIR:-}"
if [[ -n "$HOST_DIR" && -d "$HOST_DIR" ]]; then
  echo "==> Sync frameworks to host: $HOST_DIR"
  for item in App Flutter flutter_tts image_picker_ios in_app_purchase_storekit shared_preferences_foundation url_launcher_ios webview_flutter_wkwebview; do
    rm -rf "$HOST_DIR/${item}.xcframework"
    cp -R "$RELEASE_DIR/${item}.xcframework" "$HOST_DIR/"
  done
  cp -f "$OUTPUT_DIR/GeneratedPluginRegistrant.h" "$HOST_DIR/"
  cp -f "$OUTPUT_DIR/GeneratedPluginRegistrant.m" "$HOST_DIR/"
fi

echo "Done: $ZIP"
echo "IPA:  build/ios/ipa/"
echo ""
echo "Host project checklist (ITMS-91065):"
echo "  1. Replace embedded xcframeworks with this Release/ output"
echo "  2. Keep Embed & Sign (CodeSignOnCopy)"
echo "  3. Archive with Apple Distribution: Jiuming Zhang (FZLGG2K455)"
echo "  4. After archive, verify: codesign -dvv Payload/*.app/Frameworks/image_picker_ios.framework"
