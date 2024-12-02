import 'package:conference_management_system/models/paper.dart';
import 'package:conference_management_system/models/session.dart';
import 'package:conference_management_system/screens/papers/paper_tile.dart';
import 'package:flutter/material.dart';

class PapersList extends StatelessWidget {
  final List<Paper> papers;
  final String sessionId;

  const PapersList({super.key, required this.papers, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    // Sort papers by title
    final sortedPapers = List<Paper>.from(papers)
      ..sort((a, b) => a.title.compareTo(b.title));

    return ListView.builder(
      itemCount: sortedPapers.length,
      itemBuilder: (context, index) {
        final paper = sortedPapers[index];
        return PaperTile(paper: paper, sessionId: sessionId);
      },
    );
  }
}
