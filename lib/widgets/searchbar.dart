import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class Searchbar extends StatefulWidget {
  const Searchbar({super.key});

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDark = themeProvider.isDarkMode;
    final Color baseColor = isDark ? NeuColors.neuBaseDark : NeuColors.neuBase;
    final List<BoxShadow> neuShadow = isDark ? NeuShadows.neuDark : NeuShadows.neu;
    final Color textColor = isDark ? NeuColors.neuTextDark : NeuColors.neuText;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
              boxShadow: neuShadow,
            ),
            child: TextField(
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: isDark ? Colors.grey[400] : Colors.grey),
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: neuShadow,
          ),
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              backgroundColor: Colors.transparent,
              foregroundColor: textColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Text('Search', style: TextStyle(color: textColor)),
          ),
        ),
      ],
    );
  }
}
