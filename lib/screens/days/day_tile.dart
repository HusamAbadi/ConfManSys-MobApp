import 'package:conference_management_system/models/conference.dart';
import 'package:conference_management_system/models/day.dart';
import 'package:conference_management_system/screens/sessions/sessions_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayTile extends StatelessWidget {
  final Day day;
  final Conference conference;
  final int dayIncrement;
  final ValueNotifier<double> fontSizeNotifier;

  const DayTile({
    super.key,
    required this.day,
    required this.conference,
    required this.dayIncrement,
    required this.fontSizeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    Color cardBorderColor = _getCardBorderColor(now);

    return ValueListenableBuilder<double>(
      valueListenable: fontSizeNotifier,
      builder: (context, fontSize, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Card(
            margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: cardBorderColor, width: 3.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              title: Text(
                'Day $dayIncrement: ${DateFormat('EEEE, dd-MM-yyyy').format(day.date)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
              subtitle: Text(
                '${DateFormat('hh:mm a').format(day.date)} - ${DateFormat('hh:mm a').format(day.endTime)}',
                style: TextStyle(fontSize: fontSize - 2),
              ),
              onTap: () {
                // Navigate to the SessionsScreen when the day is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SessionsScreen(
                      day: day,
                      conference: conference,
                      dayIncrement: dayIncrement,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Color _getCardBorderColor(DateTime now) {
    if (now.isBefore(day.date)) {
      return Colors.orange; // Upcoming
    } else if (now.isAfter(day.endTime)) {
      return Colors.red; // Ended
    } else {
      return Colors.green; // Ongoing
    }
  }
}
