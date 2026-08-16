import 'package:flutter/material.dart';

class CoinIcon extends StatelessWidget {
  final double size;
  final bool showShadow;

  const CoinIcon({
    super.key,
    this.size = 24,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: const Color(0xFFFF8F00).withValues(alpha: 0.4),
                  blurRadius: size * 0.3,
                  offset: Offset(0, size * 0.15),
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          // 外圈 - 最浅的金色
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFFF4D6),
                  const Color(0xFFFFE5A0),
                  const Color(0xFFFFD97D),
                ],
              ),
            ),
          ),
          // 顶部高光
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.white.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // 中圈 - 橙色环
          Center(
            child: Container(
              width: size * 0.85,
              height: size * 0.85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFD97D),
                    Color(0xFFFFB84D),
                    Color(0xFFFF9F1C),
                  ],
                ),
              ),
            ),
          ),
          // 内圈 - 主体金色
          Center(
            child: Container(
              width: size * 0.7,
              height: size * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFE5A0),
                    Color(0xFFFFD97D),
                    Color(0xFFFFB84D),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  '¥',
                  style: TextStyle(
                    fontSize: size * 0.45,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFFB84D),
                    height: 1.0,
                    shadows: [
                      Shadow(
                        color: const Color(0xFFFF9F1C).withValues(alpha: 0.3),
                        offset: Offset(0, size * 0.02),
                        blurRadius: size * 0.05,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 底部阴影效果
          Positioned(
            bottom: 0,
            left: size * 0.15,
            right: size * 0.15,
            child: Container(
              height: size * 0.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFFFF9F1C).withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

