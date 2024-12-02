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

    String formattedStartTime = DateFormat('hh:mm a').format(session.startTime);
    String formattedEndTime = DateFormat('hh:mm a').format(session.endTime);

    if (session.isBreak) {
      // Design for break sessions
      return Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        color: Colors.lightGreen[200],
        child: Stack(
          children: [
            ListTile(
              leading: const Icon(
                Icons.access_time_sharp,
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
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(session.location),
                  // const SizedBox(height: 8.0),
                  // Text("Start Time: $formattedStartTime"),
                  // Text("End Time: $formattedEndTime"),
                ],
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
              },
            ),
            // Start Time Positioned at top-right
            Positioned(
              top: 8.0,
              right: 8.0,
              child: Text(
                formattedStartTime,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // End Time Positioned at bottom-right
            Positioned(
              bottom: 8.0,
              right: 8.0,
              child: Text(
                formattedEndTime,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Regular session design
      Color cardBorderColor;
      if (now.isBefore(session.startTime)) {
        cardBorderColor = Colors.orange; // Session is upcoming
      } else if (now.isAfter(session.endTime)) {
        cardBorderColor = Colors.red; // Session has ended
      } else {
        cardBorderColor = Colors.green; // Session is ongoing
      }

      return FutureProvider<List<Person>?>(
        create: (context) =>
            DatabaseService(uid: 'uid').fetchChairPersons(session.chairPersons),
        initialData: null,
        child: Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: cardBorderColor, width: 2.0),
            borderRadius:
                BorderRadius.circular(12.0), // Adjust the radius as needed
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.sensors_outlined,
                      color: Colors.blue,
                    ),
                    title: Text(
                      session.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(session.location),
                        // const SizedBox(height: 8.0),
                        Consumer<List<Person>?>(
                            builder: (context, chairPersons, child) {
                          if (chairPersons == null) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (chairPersons.isEmpty) {
                            return const Center(
                                child: Text('No chairpersons found.'));
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Chaired by: ",
                                style: TextStyle(
                                    color: Colors
                                        .black), // Normal text stays black
                              ),
                              // SingleChildScrollView to make the row scrollable horizontally
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: chairPersons.map((chairPerson) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0), // Space between names
                                      child: Text(
                                        chairPerson.name,
                                        style: const TextStyle(
                                            color: Colors
                                                .lightBlue), // Chairpersons' names in light blue
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
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
                  // Start Time Positioned at top-right
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: Text(
                      formattedStartTime,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // End Time Positioned at bottom-right
                  Positioned(
                    bottom: 8.0,
                    right: 8.0,
                    child: Text(
                      formattedEndTime,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
