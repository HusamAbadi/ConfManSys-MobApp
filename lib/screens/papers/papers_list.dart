import 'package:conference_management_system/models/paper.dart';
import 'package:conference_management_system/screens/papers/paper_tile.dart';
import 'package:flutter/material.dart';

class PapersList extends StatelessWidget {
  final List<Paper> papers;

  const PapersList({super.key, required this.papers});

  @override
  Widget build(BuildContext context) {
    // Sort papers by title
    final sortedPapers = List<Paper>.from(papers)
      ..sort((a, b) => a.title.compareTo(b.title));

    return ListView.builder(
      itemCount: sortedPapers.length,
      itemBuilder: (context, index) {
        final paper = sortedPapers[index];
        return PaperTile(paper: paper);
      },
    );
  }
}
