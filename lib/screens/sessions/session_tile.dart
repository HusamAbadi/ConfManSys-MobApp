import 'package:conference_management_system/models/conference.dart';
import 'package:conference_management_system/models/person.dart';
import 'package:conference_management_system/models/session.dart';
import 'package:conference_management_system/screens/papers/papers_screen.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SessionTile extends StatelessWidget {
  final Conference conference;
  final Session session;
  final int dayIncrement;
  final int sessionIncrement;
  final ValueNotifier<double> fontSizeNotifier;

  const SessionTile({
    super.key,
    required this.session,
    required this.conference,
    required this.sessionIncrement,
    required this.dayIncrement,
    required this.fontSizeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedStartTime = DateFormat('hh:mm a').format(session.startTime);
    String formattedEndTime = DateFormat('hh:mm a').format(session.endTime);

    if (session.isBreak) {
      return ValueListenableBuilder<double>(
        valueListenable: fontSizeNotifier,
        builder: (context, fontSize, _) {
          return Card(
            margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
            color: Colors.lightGreen[200],
            child: ListTile(
              leading: const Icon(
                Icons.access_time_sharp,
                color: Colors.brown,
                size: 30.0,
              ),
              title: Text(
                session.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.location,
                    style: TextStyle(fontSize: fontSize - 2),
                  ),
                  Text("${formattedStartTime} - ${formattedEndTime}")
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Break Details"),
                      content: Text(session.description),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      );
    } else {
      Color cardBorderColor;
      if (now.isBefore(session.startTime)) {
        cardBorderColor = Colors.orange;
      } else if (now.isAfter(session.endTime)) {
        cardBorderColor = Colors.red;
      } else {
        cardBorderColor = Colors.green;
      }

      return ValueListenableBuilder<double>(
        valueListenable: fontSizeNotifier,
        builder: (context, fontSize, _) {
          return Card(
            margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: cardBorderColor, width: 3.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.sensors_outlined,
                color: Colors.blue,
              ),
              title: Text(
                session.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location: ${session.location}",
                    style: TextStyle(fontSize: fontSize - 2),
                  ),
                  const SizedBox(height: 5),
                  Text("${formattedStartTime} - ${formattedEndTime}"),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PapersScreen.session(
                      session: session,
                      conference: conference,
                      dayIncrement: dayIncrement,
                      sessionIncrement: sessionIncrement,
                    ),
                  ),
                );
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Session Details"),
                      content: Text(session.description),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      );
    }
  }
}
