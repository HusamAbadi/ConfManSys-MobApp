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
    Color cardBorderColor;
    if (now.isBefore(conference.startDate)) {
      cardBorderColor = Colors.orange; // Upcoming
    } else if (now.isAfter(conference.endDate)) {
      cardBorderColor = Colors.red; // Ended
    } else {
      cardBorderColor = Colors.green; // Ongoing
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: cardBorderColor, width: 3.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          title: Text(
            conference.name,
            textAlign: TextAlign.center,
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
