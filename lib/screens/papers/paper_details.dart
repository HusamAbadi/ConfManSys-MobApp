import 'package:conference_management_system/models/keyword.dart';
import 'package:conference_management_system/models/paper.dart';
import 'package:conference_management_system/models/person.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:conference_management_system/shared/constants.dart';
import 'package:conference_management_system/shared/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaperDetails extends StatelessWidget {
  final Paper paper;
  final String sessionId;

  const PaperDetails({super.key, required this.paper, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> fontSizeNotifier =
        ValueNotifier(16.0); // Font size notifier

    return FutureProvider<List<Person>?>(
      create: (context) =>
          DatabaseService(uid: 'uid').fetchAuthorsByPaper(paper.authors),
      initialData: null,
      child: FutureProvider<List<Keyword>?>(
        create: (context) =>
            DatabaseService(uid: 'uid').fetchKeywords(paper.keywords),
        initialData: null,
        child: Scaffold(
          backgroundColor: bodyBackgroundColor,
          appBar: CustomAppBar(
            title: "Back",
            fontSizeNotifier: fontSizeNotifier,
            showBackButton: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                ValueListenableBuilder<double>(
                  valueListenable: fontSizeNotifier,
                  builder: (context, fontSize, _) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          paper.title,
                          style: TextStyle(
                            fontSize: fontSize + 4,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
                // Abstract
                _buildAbstractSection(fontSizeNotifier),
                const SizedBox(height: 20.0),
                // Authors
                _buildAuthorsSection(context, fontSizeNotifier),
                // Keywords
                _buildKeywordsSection(context, fontSizeNotifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAbstractSection(ValueNotifier<double> fontSizeNotifier) {
    return ValueListenableBuilder<double>(
      valueListenable: fontSizeNotifier,
      builder: (context, fontSize, _) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 500.0),
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
                  child: Text(
                    paper.abstract,
                    style: TextStyle(fontSize: fontSize),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAuthorsSection(
      BuildContext context, ValueNotifier<double> fontSizeNotifier) {
    return Consumer<List<Person>?>(
      builder: (context, authors, child) {
        if (authors == null) {
          return const Center(child: CircularProgressIndicator());
        } else if (authors.isEmpty) {
          return const Center(child: Text('No authors found.'));
        } else {
          return ValueListenableBuilder<double>(
            valueListenable: fontSizeNotifier,
            builder: (context, fontSize, _) {
              return Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Row(
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
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '- ${author.name}',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Colors.purple,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildKeywordsSection(
      BuildContext context, ValueNotifier<double> fontSizeNotifier) {
    return Consumer<List<Keyword>?>(
      builder: (context, keywords, child) {
        if (keywords == null) {
          return const Center(child: CircularProgressIndicator());
        } else if (keywords.isEmpty) {
          return const Center(child: Text('No keywords found.'));
        } else {
          return ValueListenableBuilder<double>(
            valueListenable: fontSizeNotifier,
            builder: (context, fontSize, _) {
              return Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Row(
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
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '- ${keyword.name}',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Colors.blue,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
