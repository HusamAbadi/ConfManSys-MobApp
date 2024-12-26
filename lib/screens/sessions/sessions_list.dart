import 'package:conference_management_system/models/conference.dart';
import 'package:conference_management_system/models/day.dart';
import 'package:conference_management_system/models/session.dart';
import 'package:conference_management_system/screens/sessions/session_tile.dart';
import 'package:flutter/material.dart';

class SessionsList extends StatelessWidget {
  final Conference conference;
  final Day? day;
  final List<Session> sessions;
  final int dayIncrement;
  final ValueNotifier<double> fontSizeNotifier;

  const SessionsList({
    super.key,
    this.day,
    required this.conference,
    required this.sessions,
    required this.dayIncrement,
    required this.fontSizeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const Center(child: Text('No sessions available for this day.'));
    }

    List<Session> sortedSessions = List.from(sessions)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return ListView.builder(
      itemCount: sortedSessions.length,
      itemBuilder: (context, index) {
        final session = sortedSessions[index];
        return SessionTile(
          conference: conference,
          session: session,
          dayIncrement: dayIncrement,
          sessionIncrement: index + 1,
          fontSizeNotifier: fontSizeNotifier,
        );
      },
    );
  }
}
