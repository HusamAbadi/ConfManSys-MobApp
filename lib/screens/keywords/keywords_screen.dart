import 'package:conference_management_system/models/keyword.dart';
import 'package:conference_management_system/screens/keywords/keywords_list.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:conference_management_system/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KeywordsScreen extends StatelessWidget {
  const KeywordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        title: const Text("Back to Home Screen"),
        backgroundColor: appBarColor,
        titleTextStyle: titleFontStyle,
      ),
      body: FutureProvider<List<Keyword>?>(
        create: (context) => DatabaseService(uid: 'uid').fetchAllKeywords(),
        initialData: null,
        child: Column(
          children: [
            const SizedBox(height: 50.0),
            Center(
              child: Text(
                'Keywords',
                style: titleFontStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40.0),
            const Expanded(
              child: KeywordsList(),
            ),
          ],
        ),
      ),
    );
  }
}
