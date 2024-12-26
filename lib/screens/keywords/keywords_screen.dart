import 'package:conference_management_system/models/keyword.dart';
import 'package:conference_management_system/screens/keywords/keywords_list.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:conference_management_system/shared/constants.dart';
import 'package:conference_management_system/shared/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KeywordsScreen extends StatelessWidget {
  const KeywordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> fontSizeNotifier =
        ValueNotifier(16.0); // Font size notifier

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: CustomAppBar(
        title: "Back to Home Screen",
        fontSizeNotifier: fontSizeNotifier,
        showBackButton: true,
      ),
      body: FutureProvider<List<Keyword>?>( 
        create: (context) => DatabaseService(uid: 'uid').fetchAllKeywords(),
        initialData: null,
        child: Column(
          children: [
            const SizedBox(height: 50.0),
            ValueListenableBuilder<double>(
              valueListenable: fontSizeNotifier,
              builder: (context, fontSize, _) {
                return Center(
                  child: Text(
                    'Keywords',
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
              child: KeywordsList(fontSizeNotifier: fontSizeNotifier),
            ),
          ],
        ),
      ),
    );
  }
}
