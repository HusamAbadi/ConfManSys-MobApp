import 'package:conference_management_system/models/person.dart';
import 'package:conference_management_system/screens/papers/papers_screen.dart';
import 'package:flutter/material.dart';

class AuthorsTile extends StatelessWidget {
  final Person author;

  const AuthorsTile({super.key, required this.author});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Adding elevation for shadow effect
      child: ListTile(
        title: Text(
          author.name,
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PapersScreen.author(
                author: author,
              ),
            ),
          );
        },
      ),
    );
  }
}
