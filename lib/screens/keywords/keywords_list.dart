import 'package:conference_management_system/models/keyword.dart';
import 'package:conference_management_system/screens/keywords/keywords_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KeywordsList extends StatelessWidget {
  const KeywordsList({super.key});

  @override
  Widget build(BuildContext context) {
    final keywords = Provider.of<List<Keyword>?>(context);

    if (keywords == null) {
      return const Center(
        child: CircularProgressIndicator(), // Loading indicator
      );
    }

    if (keywords.isEmpty) {
      return const Center(
        child: Text("No keywords found."),
      );
    }

    // Sort keywords by name in ascending order
    final sortedKeywords = List<Keyword>.from(keywords)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of tiles per row
        crossAxisSpacing: 0.0, // Space between columns
        mainAxisSpacing: 5.0, // Space between rows
        childAspectRatio: 1.5, // Increase the width of each tile
      ),
      itemCount: sortedKeywords.length,
      itemBuilder: (context, index) {
        return KeywordsTile(
          keyword: sortedKeywords[index],
        );
      },
    );
  }
}
