import 'package:conference_management_system/models/conference.dart';
import 'package:conference_management_system/models/day.dart';
import 'package:conference_management_system/models/session.dart';
import 'package:conference_management_system/screens/sessions/sessions_list.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:conference_management_system/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conference_management_system/shared/custom_app_bar.dart'; // Import CustomAppBar

class SessionsScreen extends StatelessWidget {
  final Day day;
  final Conference conference;
  final int dayIncrement;

  const SessionsScreen({
    super.key,
    required this.day,
    required this.conference,
    required this.dayIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> fontSizeNotifier =
        ValueNotifier(16.0); // Font size notifier

    return FutureProvider<List<Session>?>( 
      create: (context) => DatabaseService(uid: 'uid').fetchSessions(
        conference.id,
        day.id,
      ),
      initialData: null,
      child: Scaffold(
        backgroundColor: bodyBackgroundColor,
        appBar: CustomAppBar(
          title: "Back to Days Screen",
          fontSizeNotifier: fontSizeNotifier,
          showBackButton: true,
        ),
        body: _buildBody(context, fontSizeNotifier),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ValueNotifier<double> fontSizeNotifier) {
    return Column(
      children: [
        const SizedBox(height: 50.0),
        ValueListenableBuilder<double>(
          valueListenable: fontSizeNotifier,
          builder: (context, fontSize, _) {
            return Center(
              child: Column(
                children: [
                  Text(
                    conference.name,
                    style: titleFontStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize + 2,
                    ),
                  ),
                  Text(
                    "Day ${dayIncrement.toString()}",
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 40.0),
        Expanded(
          child: Consumer<List<Session>?>( 
            builder: (context, sessions, child) {
              if (sessions == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (sessions.isEmpty) {
                return const Center(
                  child: Text('No sessions available for this day.'),
                );
              }
              return SessionsList(
                conference: conference,
                day: day,
                sessions: sessions,
                dayIncrement: dayIncrement,
                fontSizeNotifier: fontSizeNotifier,
              );
            },
          ),
        ),
      ],
    );
  }
}
