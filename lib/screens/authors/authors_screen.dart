import 'package:conference_management_system/models/person.dart';
import 'package:conference_management_system/screens/authors/authors_list.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:conference_management_system/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorsScreen extends StatelessWidget {
  const AuthorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        title: const Text('Back to Home Screen'), // More descriptive title
        backgroundColor: appBarColor,
        titleTextStyle: titleFontStyle,
      ),
      body: FutureProvider<List<Person>?>(
        create: (context) => DatabaseService(uid: 'uid').fetchAllAuthors(),
        initialData: null,
        child: Column(
          children: [
            const SizedBox(height: 50.0),
            Center(
              child: Text(
                'Authors',
                style: titleFontStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40.0),
            const Expanded(
              child: AuthorsList(),
            ),
          ],
        ),
      ),
    );
  }
}
