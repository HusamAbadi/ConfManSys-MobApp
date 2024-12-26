import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final ValueNotifier<double> fontSizeNotifier;
  final double minFontSize;
  final double maxFontSize;
  final bool showBackButton; // Add a parameter to show the back button
  final List<Widget>? actions;

  CustomAppBar({
    required this.title,
    required this.fontSizeNotifier,
    this.minFontSize = 12.0,
    this.maxFontSize = 30.0,
    this.showBackButton = false, // Default is false
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.amber[400],
      automaticallyImplyLeading:
          showBackButton, // Conditionally show back button
      title: Text(
        title,
        style: TextStyle(fontSize: fontSizeNotifier.value),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.text_increase),
          onPressed: () {
            fontSizeNotifier.value =
                (fontSizeNotifier.value + 2).clamp(minFontSize, maxFontSize);
          },
          tooltip: 'Increase Font Size',
        ),
        IconButton(
          icon: const Icon(Icons.text_decrease),
          onPressed: () {
            fontSizeNotifier.value =
                (fontSizeNotifier.value - 2).clamp(minFontSize, maxFontSize);
          },
          tooltip: 'Decrease Font Size',
        ),
        if (actions != null) ...actions!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
