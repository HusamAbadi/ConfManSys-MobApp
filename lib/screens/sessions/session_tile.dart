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

  const SessionTile({
    super.key,
    required this.session,
    required this.conference,
    required this.sessionIncrement,
    required this.dayIncrement,
  });

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    if (session.isBreak) {
      // Design for break sessions
      return Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          color: Colors.lightGreen[200],
          child: ListTile(
              leading: const Icon(
                Icons.coffee,
                color: Colors.brown,
                size: 30.0,
              ),
              title: Text(
                session.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              subtitle: Text(
                "Location: ${session.location}",
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              onTap: () {
                // Show the description in a popup
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Break Details"),
                      content: Text(session.description),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              }));
    } else {
      // Regular session design
      Color circleColor;
      if (now.isBefore(session.startTime)) {
        circleColor = Colors.orange; // Session is upcoming
      } else if (now.isAfter(session.endTime)) {
        circleColor = Colors.red; // Session has ended
      } else {
        circleColor = Colors.green; // Session is ongoing
      }

      String formattedStartTime =
          DateFormat('hh:mm a').format(session.startTime);
      String formattedEndTime = DateFormat('hh:mm a').format(session.endTime);

      return FutureProvider<List<Person>?>(
        create: (context) =>
            DatabaseService(uid: 'uid').fetchChairPersons(session.chairPersons),
        initialData: null,
        child: Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundColor:
                      circleColor, // Set the color based on the status
                ),
                title: Text(
                  session.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$formattedStartTime - $formattedEndTime'),
                    Text(session.location),
                    const SizedBox(height: 8.0),
                    Consumer<List<Person>?>(
                        builder: (context, chairPersons, child) {
                      if (chairPersons == null) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (chairPersons.isEmpty) {
                        return const Center(
                            child: Text('No chairpersons found.'));
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: chairPersons.map((chairPerson) {
                          return Text(
                            chairPerson.name,
                            style: const TextStyle(color: Colors.lightBlue),
                          );
                        }).toList(),
                      );
                    }),
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
                          sessionIncrement: sessionIncrement),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}
