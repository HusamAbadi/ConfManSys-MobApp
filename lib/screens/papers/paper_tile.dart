import 'package:conference_management_system/models/paper.dart';
import 'package:conference_management_system/screens/papers/paper_details.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaperTile extends StatelessWidget {
  final Paper paper;
  final String sessionId;

  const PaperTile({super.key, required this.paper, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
      child: ListTile(
        title: Text(
          paper.title,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        trailing: sessionId != "0"
            ? IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  _saveAsFavorite(context);
                },
                tooltip: 'Save as Favorite',
              )
            : null,
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
  }

  Future<void> _saveAsFavorite(BuildContext context) async {
    try {
      // Get the current user's ID
      final user = FirebaseAuth.instance.currentUser;

      final uid = user!.uid;

      // Access the DatabaseService
      final database = DatabaseService(uid: uid);

      // Add the paper to the user's favorite papers
      await database.addFavoritePaper(paper.id);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${paper.title} saved as favorite!'),
        ),
      );
    } catch (e) {
      // Show an error message in case of failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save favorite: $e'),
        ),
      );
    }
  }
}
