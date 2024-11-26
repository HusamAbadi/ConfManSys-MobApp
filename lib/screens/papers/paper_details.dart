import 'package:conference_management_system/models/keyword.dart';
import 'package:conference_management_system/models/paper.dart';
import 'package:conference_management_system/models/person.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:conference_management_system/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaperDetails extends StatelessWidget {
  final Paper paper;

  const PaperDetails({super.key, required this.paper});

  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<Person>?>(
      // Provider for authors
      create: (context) =>
          DatabaseService(uid: 'uid').fetchAuthorsByPaper(paper.authors),
      initialData: null,
      child: FutureProvider<List<Keyword>?>(
        // Provider for keywords
        create: (context) =>
            DatabaseService(uid: 'uid').fetchKeywords(paper.keywords),
        initialData: null,
        child: Scaffold(
          backgroundColor: bodyBackgroundColor,
          appBar: AppBar(
            backgroundColor: appBarColor,
            title: const Text("Back"),
            titleTextStyle: titleFontStyle,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      paper.title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Abstract
                _buildAbstractSection(),
                SizedBox(height: 20.0),
                // Authors
                _buildAuthorsSection(context),
                // Keywords
                _buildKeywordsSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorsSection(BuildContext context) {
    return Consumer<List<Person>?>(
      builder: (context, authors, child) {
        if (authors == null) {
          return const Center(child: CircularProgressIndicator());
        } else if (authors.isEmpty) {
          return const Center(child: Text('No authors found.'));
        } else {
          return Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              children: [
                const Text("Authors:    "),
                const SizedBox(width: 10.0),
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: authors.map((author) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '- ${author.name}',
                            style: const TextStyle(color: Colors.purple),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildKeywordsSection(BuildContext context) {
    return Consumer<List<Keyword>?>(
      builder: (context, keywords, child) {
        if (keywords == null) {
          return const Center(child: CircularProgressIndicator());
        } else if (keywords.isEmpty) {
          return const Center(child: Text('No keywords found.'));
        } else {
          return Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              children: [
                const Text("Keywords: "),
                const SizedBox(width: 10.0),
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: keywords.map((keyword) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '- ${keyword.name}',
                            style: const TextStyle(color: Colors.blue),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildAbstractSection() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 550.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Text(paper.abstract),
            ),
          ),
        ),
      ),
    );
  }
}
