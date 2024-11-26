import 'package:conference_management_system/models/conference.dart';
import 'package:conference_management_system/screens/conferences/conferences_list.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:conference_management_system/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConferencesScreen extends StatelessWidget {
  const ConferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Conference>?>.value(
      value: DatabaseService(uid: 'uid').conferences,
      initialData: null,
      child: Scaffold(
        backgroundColor: bodyBackgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text('Back to Home Screen'),
          titleTextStyle: titleFontStyle,
        ),
        body: const ConferencesBody(),
      ),
    );
  }
}

class ConferencesBody extends StatelessWidget {
  const ConferencesBody({super.key});

  @override
  Widget build(BuildContext context) {
    final conferences = Provider.of<List<Conference>?>(context);

    // Show loading indicator while data is being fetched
    if (conferences == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Handle case when there are no conferences
    if (conferences.isEmpty) {
      return const Center(child: Text("No conferences available."));
    }

    return Column(
      children: [
        const SizedBox(height: 50.0),
        Center(
          child: Text(
            'Conferences',
            style: titleFontStyle.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 40.0),
        const Expanded(
          child: ConferencesList(),
        ),
      ],
    );
  }
}
