import 'package:conference_management_system/models/paper.dart';
import 'package:conference_management_system/screens/papers/paper_details.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaperTile extends StatefulWidget {
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
  State<PaperTile> createState() => _PaperTileState();
}

class _PaperTileState extends State<PaperTile> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final database = DatabaseService(uid: user.uid);
      final isAlreadyFavorite = await database.isPaperInFavorites(widget.paper.id);
      if (mounted) {
        setState(() {
          _isFavorite = isAlreadyFavorite;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: widget.fontSizeNotifier,
      builder: (context, fontSize, _) {
        return Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            title: Text(
              widget.paper.title,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.favorite_border,
                color: _isFavorite ? Colors.red : null,
              ),
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
                      PaperDetails(paper: widget.paper, sessionId: widget.sessionId),
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
      
      // Check if paper is already in favorites
      final isAlreadyFavorite = await database.isPaperInFavorites(widget.paper.id);
      if (isAlreadyFavorite) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This paper is already added to your favourite papers collection'),
          ),
        );
        return;
      }

      await database.addFavoritePaper(widget.paper.id);
      setState(() {
        _isFavorite = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.paper.title} saved as favorite!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save favorite: $e')),
      );
    }
  }
}
