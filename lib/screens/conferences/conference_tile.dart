import 'package:conference_management_system/screens/days/days_screen.dart';
import 'package:flutter/material.dart';
import 'package:conference_management_system/models/conference.dart';
import 'package:intl/intl.dart';

class ConferenceTile extends StatelessWidget {
  final Conference conference;
  final ValueNotifier<double> fontSizeNotifier;

  const ConferenceTile({
    super.key,
    required this.conference,
    required this.fontSizeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    String formattedStartDate =
        DateFormat('EEEE, yyyy-MM-dd').format(conference.startDate);
    String formattedEndDate =
        DateFormat('EEEE, yyyy-MM-dd').format(conference.endDate);

    DateTime now = DateTime.now();

    Color cardBorderColor;
    if (now.isBefore(conference.startDate)) {
      cardBorderColor = Colors.orange; // Upcoming
    } else if (now.isAfter(conference.endDate)) {
      cardBorderColor = Colors.red; // Ended
    } else {
      cardBorderColor = Colors.green; // Ongoing
    }

    return ValueListenableBuilder<double>(
      valueListenable: fontSizeNotifier,
      builder: (context, fontSize, _) {
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    conference.location,
                    style: TextStyle(fontSize: fontSize - 2),
                  ),
                  const SizedBox(height: 4),
                  Text('Start: $formattedStartDate',
                      style: TextStyle(fontSize: fontSize - 2)),
                  Text('End: $formattedEndDate',
                      style: TextStyle(fontSize: fontSize - 2)),
                ],
              ),
              onTap: () {
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
      },
    );
  }
}
