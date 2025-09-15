import 'dart:math';

import 'package:blog_app/providers/theme_provider.dart';
import 'package:flutter/material.dart';

class NeuLoading extends StatefulWidget {
  final bool isDark;
  const NeuLoading({super.key, required this.isDark});

  @override
  State<NeuLoading> createState() => _NeuLoadingState();
}

class _NeuLoadingState extends State<NeuLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isDark ? NeuColors.neuBaseDark : NeuColors.neuBase;
    final textColor = widget.isDark ? NeuColors.neuTextDark : NeuColors.neuText;
    final shadows = widget.isDark ? NeuShadows.neuDark : NeuShadows.neu;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            children: List.generate(8, (index) {
              final angle = (2 * pi / 8) * index;
              const radius = 20.0;
              final dx = radius * cos(angle);
              final dy = radius * sin(angle);

              final progress = (_controller.value + (index / 8)) % 1.0; // stagger effect
              final scale = 0.5 + (sin(progress * 2 * pi) + 1) / 2;

              return Transform.translate(
                offset: Offset(dx + 20, dy + 20),
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: baseColor,
                      shape: BoxShape.circle,
                      boxShadow: shadows,
                    ),
                    child: Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: textColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
