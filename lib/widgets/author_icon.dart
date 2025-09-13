import 'package:flutter/material.dart';

class AuthorIcon extends StatelessWidget {
  final String? author;
  final double width;
  final double height;
  final bool isDark;

  const AuthorIcon({super.key, this.author, required this.width, required this.height, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final initial = (author != null && author!.isNotEmpty) ? author![0].toUpperCase() : "A";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: isDark ? Colors.white12 : Colors.black12,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.white12 : Colors.black12,
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 8),
          child: Text(
            initial,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.blue.shade200 : Colors.blue.shade700,
            ),
          ),
        ),
        Text(
          author ?? "Anonymous",
          style: TextStyle(
            fontSize: 14, // text-sm
            fontWeight: FontWeight.w500, // font-medium
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFFE0E0E0) // dark:text-neuTextDark
                : const Color(0xFF4A5568), // text-neuText
          ),
        ),
      ],
    );
  }
}
