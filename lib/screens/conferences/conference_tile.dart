import 'package:conference_management_system/screens/days/days_screen.dart';
import 'package:flutter/material.dart';
import 'package:conference_management_system/models/conference.dart';
import 'package:intl/intl.dart';

class ConferenceTile extends StatelessWidget {
  final Conference conference;

  const ConferenceTile({super.key, required this.conference});

  @override
  Widget build(BuildContext context) {
    // Format the start and end dates
    String formattedStartDate =
        DateFormat('EEEE, yyyy-MM-dd').format(conference.startDate);
    String formattedEndDate =
        DateFormat('EEEE, yyyy-MM-dd').format(conference.endDate);

    // Get the current date and time
    DateTime now = DateTime.now();

    // Determine the status of the conference
    Color circleColor;
    if (now.isBefore(conference.startDate)) {
      circleColor = Colors.orange; // Upcoming
    } else if (now.isAfter(conference.endDate)) {
      circleColor = Colors.red; // Ended
    } else {
      circleColor = Colors.green; // Ongoing
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 4, // Adds a slight shadow for depth
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: circleColor,
          ),
          title: Text(
            conference.name,
            textAlign: TextAlign.center, // Center title
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                conference.location,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4), // Space between lines
              Text('Start: $formattedStartDate'),
              Text('End: $formattedEndDate'),
            ],
          ),
          onTap: () {
            print(conference.days);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DaysScreen(conference: conference),
              ),
            );
          },
        ),
      ),
    );
  }
}
