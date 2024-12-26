import 'package:conference_management_system/models/keyword.dart';
import 'package:conference_management_system/screens/papers/papers_screen.dart';
import 'package:flutter/material.dart';

class KeywordsTile extends StatelessWidget {
  final Keyword keyword;
  final ValueNotifier<double> fontSizeNotifier;

  const KeywordsTile({
    super.key,
    required this.keyword,
    required this.fontSizeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: fontSizeNotifier,
      builder: (context, fontSize, _) {
        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
              keyword.name,
              textAlign: TextAlign.center,
              maxLines: 2,
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
                  builder: (context) => PapersScreen.keyword(
                    keyword: keyword,
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
