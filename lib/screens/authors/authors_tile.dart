import 'package:conference_management_system/models/person.dart';
import 'package:conference_management_system/screens/papers/papers_screen.dart';
import 'package:flutter/material.dart';

class AuthorsTile extends StatelessWidget {
  final Person author;
  final ValueNotifier<double> fontSizeNotifier;

  const AuthorsTile({
    super.key,
    required this.author,
    required this.fontSizeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: fontSizeNotifier,
      builder: (context, fontSize, _) {
        return Card(
          elevation: 4,
          child: ListTile(
            title: Text(
              author.name,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize - 2,
              ),
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
      },
    );
  }
}
