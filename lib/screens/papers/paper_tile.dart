import 'package:conference_management_system/models/paper.dart';
import 'package:conference_management_system/screens/papers/paper_details.dart';
import 'package:flutter/material.dart';

class PaperTile extends StatelessWidget {
  final Paper paper;

  const PaperTile({super.key, required this.paper});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
      child: ListTile(
        title: Text(paper.title,
            style:
                const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaperDetails(paper: paper),
            ),
          );
        },
      ),
    );
  }
}
