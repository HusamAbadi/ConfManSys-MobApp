import 'package:conference_management_system/models/person.dart';
import 'package:conference_management_system/screens/authors/authors_list.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:conference_management_system/shared/constants.dart';
import 'package:conference_management_system/shared/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorsScreen extends StatelessWidget {
  const AuthorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> fontSizeNotifier =
        ValueNotifier(16.0); // Font size notifier

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: CustomAppBar(
        title: 'Back to Home Screen',
        fontSizeNotifier: fontSizeNotifier,
        showBackButton: true,
      ),
      body: FutureProvider<List<Person>?>(
        create: (context) => DatabaseService(uid: 'uid').fetchAllAuthors(),
        initialData: null,
        child: Column(
          children: [
            const SizedBox(height: 50.0),
            ValueListenableBuilder<double>(
              valueListenable: fontSizeNotifier,
              builder: (context, fontSize, _) {
                return Center(
                  child: Text(
                    'Authors',
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
              child: AuthorsList(fontSizeNotifier: fontSizeNotifier),
            ),
          ],
        ),
      ),
    );
  }
}
