import 'package:blog_app/providers/theme_provider.dart';
import 'package:flutter/material.dart';

class NeuContainer extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;
  double? width;
  double? height;

   NeuContainer({
    super.key,
    required this.child,
    required this.isDark,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = 16,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final container = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? NeuColors.neuBaseDark : NeuColors.neuBase,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isDark ? NeuShadows.neuDark : NeuShadows.neu,
      ),
      child: child,
    );

    return onTap != null ? GestureDetector(onTap: onTap, child: container) : container;
  }
}
