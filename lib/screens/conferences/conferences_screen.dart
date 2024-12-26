import 'package:conference_management_system/models/conference.dart';
import 'package:conference_management_system/screens/conferences/conferences_list.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:conference_management_system/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conference_management_system/shared/custom_app_bar.dart'; // Import the CustomAppBar

class ConferencesScreen extends StatelessWidget {
  final ValueNotifier<double> fontSizeNotifier = ValueNotifier(16.0);

  ConferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Conference>?>.value(
      value: DatabaseService(uid: 'uid').conferences,
      initialData: null,
      child: Scaffold(
        backgroundColor: bodyBackgroundColor,
        appBar: CustomAppBar(
          title: 'Conferences',
          fontSizeNotifier: fontSizeNotifier,
          showBackButton: true,
        ),
        body: ConferencesBody(fontSizeNotifier: fontSizeNotifier),
      ),
    );
  }
}

class ConferencesBody extends StatelessWidget {
  final ValueNotifier<double> fontSizeNotifier;

  const ConferencesBody({required this.fontSizeNotifier, super.key});

  @override
  Widget build(BuildContext context) {
    final conferences = Provider.of<List<Conference>?>(context);

    return ValueListenableBuilder<double>(
      valueListenable: fontSizeNotifier,
      builder: (context, fontSize, child) {
        // Show loading indicator while data is being fetched
        if (conferences == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle case when there are no conferences
        if (conferences.isEmpty) {
          return Center(
            child: Text(
              "No conferences available.",
              style: TextStyle(fontSize: fontSize),
            ),
          );
        }

        return Column(
          children: [
            const SizedBox(height: 50.0),
            Center(
              child: Text(
                'Conferences',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize + 6,
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            Expanded(
              child: ConferencesList(fontSizeNotifier: fontSizeNotifier),
            ),
          ],
        );
      },
    );
  }
}
