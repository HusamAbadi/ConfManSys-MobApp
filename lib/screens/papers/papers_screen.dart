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

class PapersScreen extends StatelessWidget {
  final Session? session;
  final Conference? conference;
  final Person? author;
  final Keyword? keyword;
  final int? dayIncrement;
  final int? sessionIncrement;

  // Constructor for SessionTile navigation
  const PapersScreen.session({
    super.key,
    required this.session,
    required this.conference,
    this.dayIncrement,
    this.sessionIncrement,
  })  : author = null,
        keyword = null;

  // Constructor for AuthorsTile navigation
  const PapersScreen.author({
    super.key,
    required this.author,
  })  : session = null,
        conference = null,
        keyword = null,
        dayIncrement = null,
        sessionIncrement = null;

  // Constructor for KeywordsTile navigation
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
    // Select which screen to build based on available parameters
    if (author != null) {
      return _buildAuthorPapersScreen();
    } else if (keyword != null) {
      return _buildKeywordPapersScreen();
    } else {
      return _buildSessionPapersScreen();
    }
  }

  Widget _buildSessionPapersScreen() {
    return _buildPapersScreen(
      appBarTitle: "Back to Sessions Screen",
      title: "${conference?.name}",
      fetchPapers: () =>
          DatabaseService(uid: 'uid').fetchPapers(session!.papers),
    );
  }

  Widget _buildAuthorPapersScreen() {
    return _buildPapersScreen(
      appBarTitle: "Back to Authors Screen",
      title: "Papers by ${author!.name}",
      fetchPapers: () =>
          DatabaseService(uid: 'uid').fetchPapersByAuthor(author!.id),
    );
  }

  Widget _buildKeywordPapersScreen() {
    return _buildPapersScreen(
      appBarTitle: 'Back to Keywords Screen',
      title: "${keyword!.name} keyword",
      fetchPapers: () =>
          DatabaseService(uid: 'uid').fetchPapersByKeyword(keyword!.id),
    );
  }

  Widget _buildPapersScreen({
    required String title,
    required Future<List<Paper>?> Function() fetchPapers,
    required String appBarTitle,
  }) {
    return FutureProvider<List<Paper>?>(
      create: (context) => fetchPapers(),
      initialData: null,
      child: Scaffold(
        backgroundColor: bodyBackgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text(appBarTitle),
          titleTextStyle: titleFontStyle,
        ),
        body: Column(
          children: [
            const SizedBox(height: 50.0),
            Center(
              child: Text(
                title,
                style: titleFontStyle.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
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
                  return PapersList(papers: papers);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
