import 'package:conference_management_system/models/keyword.dart';
import 'package:conference_management_system/screens/papers/papers_screen.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:flutter/material.dart';

class KeywordsTile extends StatelessWidget {
  final Keyword keyword;
  final ValueNotifier<double> fontSizeNotifier;

  const KeywordsTile({
    super.key,
    required this.keyword,
    required this.fontSizeNotifier,
  });

  Future<int> _fetchPaperCount() async {
    try {
      final papers = await DatabaseService(uid: 'uid')
          .fetchPapersByKeyword(keyword.id); // Fetch papers for the keyword
      return papers.length; // Return the count
    } catch (e) {
      return 0; // Return 0 if an error occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: fontSizeNotifier,
      builder: (context, fontSize, _) {
        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 8.0,
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    keyword.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize - 2,
                    ),
                  ),
                ),
                FutureBuilder<int>(
                  future: _fetchPaperCount(), // Fetch the paper count
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: fontSize - 4,
                          color: Colors.grey,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(
                        'Error',
                        style: TextStyle(
                          fontSize: fontSize - 4,
                          color: Colors.red,
                        ),
                      );
                    }
                    return Text(
                      '${snapshot.data}',
                      style: TextStyle(
                        fontSize: fontSize - 4,
                        color: Colors.blue,
                      ),
                    );
                  },
                ),
              ],
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
