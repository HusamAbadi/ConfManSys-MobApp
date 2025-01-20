import 'package:conference_management_system/models/paper.dart';
import 'package:conference_management_system/models/person.dart';
import 'package:conference_management_system/models/keyword.dart';
import 'package:conference_management_system/screens/papers/paper_details.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:conference_management_system/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:conference_management_system/shared/custom_app_bar.dart';

class FavoritePapersScreen extends StatelessWidget {
  const FavoritePapersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final ValueNotifier<double> fontSizeNotifier =
        ValueNotifier(16.0); // Font size notifier

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: CustomAppBar(
        title: 'Back to Home Screen',
        fontSizeNotifier: fontSizeNotifier,
        showBackButton: true,
      ),
      body: StreamBuilder<List<Paper>>(
        stream: DatabaseService(uid: user?.uid ?? '').streamFavoritePapers(),
        builder: (context, snapshot) {
          return Column(
            children: [
              const SizedBox(height: 50.0),
              ValueListenableBuilder<double>(
                valueListenable: fontSizeNotifier,
                builder: (context, fontSize, _) {
                  return Center(
                    child: Text(
                      'Favorite Papers',
                      style: titleFontStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize + 4,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40.0),
              Expanded(
                child: FavoritePapersList(
                  papers: snapshot.data,
                  isLoading: snapshot.connectionState == ConnectionState.waiting,
                  fontSizeNotifier: fontSizeNotifier,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FavoritePapersList extends StatelessWidget {
  final List<Paper>? papers;
  final bool isLoading;
  final ValueNotifier<double> fontSizeNotifier;

  const FavoritePapersList({
    super.key,
    required this.papers,
    required this.isLoading,
    required this.fontSizeNotifier,
  });

  Future<void> _removePaper(BuildContext context, Paper paper) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final database = DatabaseService(uid: user.uid);
      await database.removeFavoritePaper(paper.id);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${paper.title} removed from favorites')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove paper from favorites')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (papers == null || papers!.isEmpty) {
      return ValueListenableBuilder<double>(
        valueListenable: fontSizeNotifier,
        builder: (context, fontSize, _) {
          return Center(
            child: Text(
              'No favorite papers yet',
              style: TextStyle(fontSize: fontSize),
            ),
          );
        },
      );
    }

    final sortedPapers = List<Paper>.from(papers!)
      ..sort((a, b) => a.title.compareTo(b.title));

    return ListView.builder(
      itemCount: sortedPapers.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaperDetails(
                  paper: sortedPapers[index],
                  sessionId: '',
                ),
              ),
            );
          },
          child: ValueListenableBuilder<double>(
            valueListenable: fontSizeNotifier,
            builder: (context, fontSize, _) {
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: FutureProvider<List<Person>?>(
                  create: (context) => DatabaseService(uid: 'uid')
                      .fetchAuthorsByPaper(sortedPapers[index].authors),
                  initialData: null,
                  child: FutureProvider<List<Keyword>?>(
                    create: (context) => DatabaseService(uid: 'uid')
                        .fetchKeywords(sortedPapers[index].keywords),
                    initialData: null,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  sortedPapers[index].title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removePaper(context, sortedPapers[index]),
                                tooltip: 'Remove from favorites',
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            margin: const EdgeInsets.only(bottom: 8.0),
                            child: Consumer<List<Person>?>(
                              builder: (context, authors, child) {
                                if (authors == null) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (authors.isEmpty) {
                                  return Text(
                                    'No authors found.',
                                    style: TextStyle(fontSize: fontSize - 2),
                                  );
                                }
                                return Row(
                                  children: [
                                    const Text("Authors:"),
                                    const SizedBox(width: 10.0),
                                    Flexible(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: authors.map((author) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                '- ${author.name}',
                                                style: TextStyle(
                                                  fontSize: fontSize - 2,
                                                  color: Colors.purple,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 8.0),
                            child: Consumer<List<Keyword>?>(
                              builder: (context, keywords, child) {
                                if (keywords == null) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (keywords.isEmpty) {
                                  return Text(
                                    'No keywords found.',
                                    style: TextStyle(fontSize: fontSize - 2),
                                  );
                                }
                                return Row(
                                  children: [
                                    const Text("Keywords:"),
                                    const SizedBox(width: 10.0),
                                    Flexible(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: keywords.map((keyword) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                '- ${keyword.name}',
                                                style: TextStyle(
                                                  fontSize: fontSize - 2,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
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
