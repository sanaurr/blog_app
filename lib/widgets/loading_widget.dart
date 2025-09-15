import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blog_app/providers/theme_provider.dart';
import 'neu_loading.dart'; // adjust import path

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return Stack(
      children: [
        /// Blurred background overlay
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withAlpha(50), // semi-transparent tint
            ),
          ),
        ),

        /// Centered NeuLoading
        Center(
          child: NeuLoading(isDark: isDark),
        ),
      ],
    );
  }
}
