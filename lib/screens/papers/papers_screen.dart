import 'package:conference_management_system/models/conference.dart';
import 'package:conference_management_system/models/keyword.dart';
import 'package:conference_management_system/models/paper.dart';
import 'package:conference_management_system/models/person.dart';
import 'package:conference_management_system/models/session.dart';
import 'package:conference_management_system/screens/papers/papers_list.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:conference_management_system/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conference_management_system/shared/custom_app_bar.dart';

class PapersScreen extends StatelessWidget {
  final Session? session;
  final Conference? conference;
  final Person? author;
  final Keyword? keyword;
  final int? dayIncrement;
  final int? sessionIncrement;

  const PapersScreen.session({
    super.key,
    required this.session,
    required this.conference,
    this.dayIncrement,
    this.sessionIncrement,
  })  : author = null,
        keyword = null;

  const PapersScreen.author({
    super.key,
    required this.author,
  })  : session = null,
        conference = null,
        keyword = null,
        dayIncrement = null,
        sessionIncrement = null;

  const PapersScreen.keyword({
    super.key,
    required this.keyword,
  })  : session = null,
        conference = null,
        author = null,
        dayIncrement = null,
        sessionIncrement = null;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> fontSizeNotifier =
        ValueNotifier(16.0); // Font size notifier

    if (author != null) {
      return _buildAuthorPapersScreen(fontSizeNotifier);
    } else if (keyword != null) {
      return _buildKeywordPapersScreen(fontSizeNotifier);
    } else {
      return _buildSessionPapersScreen(fontSizeNotifier);
    }
  }

  Widget _buildSessionPapersScreen(ValueNotifier<double> fontSizeNotifier) {
    return _buildPapersScreen(
      fontSizeNotifier: fontSizeNotifier,
      appBarTitle: "Back to Sessions Screen",
      title: "${session?.title}",
      fetchPapers: () =>
          DatabaseService(uid: 'uid').fetchPapers(session!.papers),
    );
  }

  Widget _buildAuthorPapersScreen(ValueNotifier<double> fontSizeNotifier) {
    return _buildPapersScreen(
      fontSizeNotifier: fontSizeNotifier,
      appBarTitle: "Back to Authors Screen",
      title: "Papers by ${author!.name}",
      fetchPapers: () =>
          DatabaseService(uid: 'uid').fetchPapersByAuthor(author!.id),
    );
  }

  Widget _buildKeywordPapersScreen(ValueNotifier<double> fontSizeNotifier) {
    return _buildPapersScreen(
      fontSizeNotifier: fontSizeNotifier,
      appBarTitle: 'Back to Keywords Screen',
      title: "${keyword!.name} keyword",
      fetchPapers: () =>
          DatabaseService(uid: 'uid').fetchPapersByKeyword(keyword!.id),
    );
  }

  Widget _buildPapersScreen({
    required ValueNotifier<double> fontSizeNotifier,
    required String appBarTitle,
    required String title,
    required Future<List<Paper>?> Function() fetchPapers,
  }) {
    return FutureProvider<List<Paper>?>(
      create: (context) => fetchPapers(),
      initialData: null,
      child: Scaffold(
        backgroundColor: bodyBackgroundColor,
        appBar: CustomAppBar(
          title: appBarTitle,
          fontSizeNotifier: fontSizeNotifier,
          showBackButton: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 50.0),
            ValueListenableBuilder<double>(
              valueListenable: fontSizeNotifier,
              builder: (context, fontSize, _) {
                return Center(
                  child: Text(
                    title,
                    style: titleFontStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize + 4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            const SizedBox(height: 40.0),
            Expanded(
              child: Consumer<List<Paper>?>(
                builder: (context, papers, child) {
                  if (papers == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (papers.isEmpty) {
                    return const Center(child: Text('No papers available.'));
                  }
                  return PapersList(
                    papers: papers,
                    sessionId: session?.id.toString() ?? "0",
                    fontSizeNotifier: fontSizeNotifier,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
