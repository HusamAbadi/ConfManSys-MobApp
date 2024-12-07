import 'package:conference_management_system/models/paper.dart';
import 'package:conference_management_system/models/person.dart';
import 'package:conference_management_system/models/keyword.dart';
import 'package:conference_management_system/screens/papers/paper_details.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:conference_management_system/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritePapersScreen extends StatelessWidget {
  const FavoritePapersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        title: const Text('Back to Home Screen'),
        backgroundColor: appBarColor,
        titleTextStyle: titleFontStyle,
      ),
      body: FutureProvider<List<Paper>?>(
        create: (context) =>
            DatabaseService(uid: user?.uid ?? '').fetchFavoritePapers(),
        initialData: null,
        child: Column(
          children: [
            const SizedBox(height: 50.0),
            Center(
              child: Text(
                'Favorite Papers',
                style: titleFontStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40.0),
            const Expanded(
              child: FavoritePapersList(),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritePapersList extends StatelessWidget {
  const FavoritePapersList({super.key});

  @override
  Widget build(BuildContext context) {
    final papers = Provider.of<List<Paper>?>(context);

    if (papers == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (papers.isEmpty) {
      return const Center(
        child: Text(
          'No favorite papers yet',
          style: TextStyle(fontSize: 18.0),
        ),
      );
    }

    // Sort papers by title
    papers.sort((a, b) => a.title.compareTo(b.title));

    return ListView.builder(
      itemCount: papers.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaperDetails(
                  paper: papers[index],
                  sessionId:
                      '', // Since this is from favorites, we don't have a session ID
                ),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: FutureProvider<List<Person>?>(
              create: (context) => DatabaseService(uid: 'uid')
                  .fetchAuthorsByPaper(papers[index].authors),
              initialData: null,
              child: FutureProvider<List<Keyword>?>(
                create: (context) => DatabaseService(uid: 'uid')
                    .fetchKeywords(papers[index].keywords),
                initialData: null,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        papers[index].title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
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
                              return const Center(
                                  child: Text('No authors found.'));
                            }
                            return Row(
                              children: [
                                const Text("Authors: "),
                                const SizedBox(width: 10.0),
                                Flexible(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: authors.map((author) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            '- ${author.name}',
                                            style: const TextStyle(
                                                color: Colors.purple),
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
                              return const Center(
                                  child: Text('No keywords found.'));
                            }
                            return Row(
                              children: [
                                const Text("Keywords: "),
                                const SizedBox(width: 10.0),
                                Flexible(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: keywords.map((keyword) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            '- ${keyword.name}',
                                            style: const TextStyle(
                                                color: Colors.blue),
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
          ),
        );
      },
    );
  }
}
