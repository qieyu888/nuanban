import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedLikeButton extends StatefulWidget {
  final bool isLiked;
  final VoidCallback onTap;
  final String label;
  final double iconSize;
  final double fontSize;

  const AnimatedLikeButton({
    super.key,
    required this.isLiked,
    required this.onTap,
    required this.label,
    this.iconSize = 18,
    this.fontSize = 14,
  });

  @override
  State<AnimatedLikeButton> createState() => _AnimatedLikeButtonState();
}

class _AnimatedLikeButtonState extends State<AnimatedLikeButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _burstController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _burstAnimation;
  bool _showBurst = false;

  @override
  void initState() {
    super.initState();
    
    // 缩放动画控制器
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    // 爆炸动画控制器
    _burstController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeOut,
      ),
    );
    
    _burstAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _burstController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _burstController.dispose();
    super.dispose();
  }

  void _handleTap() {
    // 保存点击前的状态
    final wasLiked = widget.isLiked;
    
    // 触发回调（更新状态）
    widget.onTap();
    
    // 播放缩放动画
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });
    
    // 如果是从未点赞变为点赞，播放爆炸动画
    if (!wasLiked) {
      setState(() {
        _showBurst = true;
      });
      _burstController.forward().then((_) {
        _burstController.reset();
        setState(() {
          _showBurst = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // 爆炸效果 - 圆形扩散
          if (_showBurst)
            AnimatedBuilder(
              animation: _burstAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: (1.0 - _burstAnimation.value).clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: 1.0 + _burstAnimation.value * 1.5,
                    child: Container(
                      width: widget.iconSize * 3,
                      height: widget.iconSize * 3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFF609F),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          
          // 粒子效果
          if (_showBurst)
            ...List.generate(8, (index) {
              final angle = (index * math.pi * 2) / 8;
              return AnimatedBuilder(
                animation: _burstAnimation,
                builder: (context, child) {
                  final distance = _burstAnimation.value * widget.iconSize * 2;
                  final x = math.cos(angle) * distance;
                  final y = math.sin(angle) * distance;
                  
                  return Transform.translate(
                    offset: Offset(x, y),
                    child: Opacity(
                      opacity: (1.0 - _burstAnimation.value).clamp(0.0, 1.0),
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF609F),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          
          // 主按钮
          ScaleTransition(
            scale: _scaleAnimation,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.isLiked ? Icons.favorite : Icons.favorite_border,
                  size: widget.iconSize,
                  color: widget.isLiked
                      ? const Color(0xFFFF609F)
                      : const Color(0xFF999999),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    color: widget.isLiked
                        ? const Color(0xFFFF609F)
                        : const Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
