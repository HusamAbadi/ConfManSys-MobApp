import 'package:conference_management_system/models/keyword.dart';
import 'package:conference_management_system/screens/papers/papers_screen.dart';
import 'package:flutter/material.dart';

class KeywordsTile extends StatelessWidget {
  final Keyword keyword;
  const KeywordsTile({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Add elevation for shadow effect
      margin: const EdgeInsets.all(8.0), // Add margin around the card
      child: ListTile(
        title: Text(
          keyword.name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PapersScreen.keyword(
                keyword: keyword,
              ),
            ),
          );
        },
      ),
    );
  }
}
