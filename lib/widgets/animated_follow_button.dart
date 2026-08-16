import 'package:flutter/material.dart';

class AnimatedFollowButton extends StatefulWidget {
  final bool isFollowing;
  final VoidCallback onTap;
  final EdgeInsets padding;
  final double fontSize;

  const AnimatedFollowButton({
    super.key,
    required this.isFollowing,
    required this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    this.fontSize = 13,
  });

  @override
  State<AnimatedFollowButton> createState() => _AnimatedFollowButtonState();
}

class _AnimatedFollowButtonState extends State<AnimatedFollowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.9),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.1),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1.0),
        weight: 25,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap();
    
    // 播放动画
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                padding: widget.padding,
                decoration: BoxDecoration(
                  gradient: widget.isFollowing
                      ? null
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF9D31FF),
                            Color(0xFFF260FF),
                            Color(0xFFFF609F),
                          ],
                        ),
                  color: widget.isFollowing ? const Color(0xFFF7F8F8) : null,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: widget.isFollowing
                      ? null
                      : [
                          BoxShadow(
                            color: const Color(0xFF9D31FF).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.isFollowing)
                      const Icon(
                        Icons.check,
                        size: 14,
                        color: Color(0xFF666666),
                      ),
                    if (widget.isFollowing) const SizedBox(width: 4),
                    Text(
                      widget.isFollowing ? '已关注' : '关注',
                      style: TextStyle(
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.w500,
                        color: widget.isFollowing
                            ? const Color(0xFF666666)
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
