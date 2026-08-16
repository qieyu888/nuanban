#!/usr/bin/env bash
# Xcode Run Script (host app) — re-sign Flutter plugin frameworks after Embed.
# Fixes ITMS-91065 when CodeSignOnCopy drops SDK signatures on CI.
#
# Add as a Build Phase AFTER "Embed Frameworks":
#   Shell: /bin/sh
#   Script: "${SRCROOT}/nuanban/MitigateMultiKernelFilter/resign_flutter_frameworks.sh"
#   Or copy this file into the host project and point to it.
set -euo pipefail

SIGN_ID="${EXPANDED_CODE_SIGN_IDENTITY:-}"
if [[ -z "$SIGN_ID" || "$SIGN_ID" == "-" ]]; then
  SIGN_ID="Apple Distribution: Jiuming Zhang (FZLGG2K455)"
fi

APP_FRAMEWORKS="${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
if [[ ! -d "$APP_FRAMEWORKS" ]]; then
  echo "note: no Frameworks folder yet: $APP_FRAMEWORKS"
  exit 0
fi

echo "Re-signing Flutter frameworks in $APP_FRAMEWORKS with: $SIGN_ID"

# Only re-sign known Flutter plugin / app frameworks (avoid touching other SDKs).
for name in \
  App \
  Flutter \
  image_picker_ios \
  url_launcher_ios \
  webview_flutter_wkwebview \
  shared_preferences_foundation \
  in_app_purchase_storekit \
  flutter_tts
do
  fw="$APP_FRAMEWORKS/${name}.framework"
  [[ -d "$fw" ]] || continue

  # Nested privacy bundles first
  find "$fw" -name '*.bundle' -type d | while read -r bundle; do
    /usr/bin/codesign --force --sign "$SIGN_ID" --timestamp --generate-entitlement-der "$bundle" || true
  done

  echo "codesign $fw"
  /usr/bin/codesign --force --sign "$SIGN_ID" --timestamp --generate-entitlement-der "$fw"
  /usr/bin/codesign --verify --strict "$fw"
done

echo "Flutter framework re-sign done."
