import 'package:blog_app/providers/theme_provider.dart';
import 'package:flutter/material.dart';

class NeuButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isDark;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  IconData? icon;
  double? width;
  double? height;

  NeuButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isDark,
    required this.padding,
    required this.borderRadius,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: isDark ? NeuColors.neuBaseDark : NeuColors.neuBase,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: isDark ? NeuShadows.neuDark : NeuShadows.neuInset,
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, color: isDark ? NeuColors.neuTextDark : NeuColors.neuText, size: 20)
              : Text(
                  label,
                  style: TextStyle(
                    color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
