import 'package:conference_management_system/models/paper.dart';
import 'package:conference_management_system/screens/papers/paper_details.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaperTile extends StatelessWidget {
  final Paper paper;
  final String sessionId;
  final ValueNotifier<double> fontSizeNotifier;

  const PaperTile({
    super.key,
    required this.paper,
    required this.sessionId,
    required this.fontSizeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: fontSizeNotifier,
      builder: (context, fontSize, _) {
        return Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            title: Text(
              paper.title,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                _saveAsFavorite(context);
              },
              tooltip: 'Save as Favorite',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PaperDetails(paper: paper, sessionId: sessionId),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _saveAsFavorite(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user!.uid;
      final database = DatabaseService(uid: uid);
      await database.addFavoritePaper(paper.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${paper.title} saved as favorite!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save favorite: $e')),
      );
    }
  }
}
