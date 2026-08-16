import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// 打开全屏图片画廊（支持左右滑动、双指缩放，底部展示文案）
void openImageGallery(
  BuildContext context, {
  required List<String> imageUrls,
  int initialIndex = 0,
  String? content,
  String? username,
}) {
  if (imageUrls.isEmpty) return;
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: _ImageGalleryViewerPage(
            imageUrls: imageUrls,
            initialIndex: initialIndex.clamp(0, imageUrls.length - 1),
            content: content,
            username: username,
          ),
        );
      },
    ),
  );
}

/// 可点击的缩略图，点击后打开画廊
Widget buildTappableGalleryImage({
  required BuildContext context,
  required List<String> allUrls,
  required int index,
  required String imageUrl,
  required double aspectRatio,
  double borderRadius = 12,
  String? content,
  String? username,
}) {
  return GestureDetector(
    onTap: () => openImageGallery(
      context,
      imageUrls: allUrls,
      initialIndex: index,
      content: content,
      username: username,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Container(color: Colors.grey[200]),
        ),
      ),
    ),
  );
}

class _ImageGalleryViewerPage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String? content;
  final String? username;

  const _ImageGalleryViewerPage({
    required this.imageUrls,
    required this.initialIndex,
    this.content,
    this.username,
  });

  bool get _hasCaption =>
      (content?.trim().isNotEmpty ?? false) ||
      (username?.trim().isNotEmpty ?? false);

  @override
  State<_ImageGalleryViewerPage> createState() =>
      _ImageGalleryViewerPageState();
}

class _ImageGalleryViewerPageState extends State<_ImageGalleryViewerPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            pageController: _pageController,
            itemCount: widget.imageUrls.length,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            onPageChanged: (index) => setState(() => _currentIndex = index),
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(
                color: Colors.white54,
                strokeWidth: 2,
              ),
            ),
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(widget.imageUrls[index]),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained * 0.9,
                maxScale: PhotoViewComputedScale.covered * 3,
                heroAttributes: PhotoViewHeroAttributes(
                  tag: widget.imageUrls[index],
                ),
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white38,
                    size: 48,
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  if (widget.imageUrls.length > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${_currentIndex + 1} / ${widget.imageUrls.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (widget._hasCaption)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.55),
                        Colors.black.withValues(alpha: 0.92),
                      ],
                      stops: const [0.0, 0.35, 1.0],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 32, 16, bottomInset + 16),
                    child: _CaptionBlock(
                      username: widget.username,
                      content: widget.content,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CaptionBlock extends StatelessWidget {
  final String? username;
  final String? content;

  const _CaptionBlock({this.username, this.content});

  @override
  Widget build(BuildContext context) {
    final name = username?.trim() ?? '';
    final text = content?.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (name.isNotEmpty)
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (name.isNotEmpty && text.isNotEmpty) const SizedBox(height: 8),
        if (text.isNotEmpty)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 120),
            child: SingleChildScrollView(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
