import 'package:conference_management_system/models/conference.dart';
import 'package:conference_management_system/models/day.dart';
import 'package:conference_management_system/screens/sessions/sessions_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayTile extends StatelessWidget {
  final Day day;
  final Conference conference;
  final int dayIncrement;

  const DayTile({
    super.key,
    required this.day,
    required this.conference,
    required this.dayIncrement,
  });

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    Color circleColor = _getCircleColor(now);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: circleColor, // Set the color based on the status
          ),
          title: Text(
            'Day $dayIncrement: ${DateFormat('EEEE, dd-MM-yyyy').format(day.date)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${DateFormat('hh:mm a').format(day.date)} - ${DateFormat('hh:mm a').format(day.endTime)}',
          ),
          onTap: () {
            // Navigate to the SessionsScreen when the day is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SessionsScreen(
                    day: day,
                    conference: conference,
                    dayIncrement: dayIncrement),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getCircleColor(DateTime now) {
    if (now.isBefore(day.date)) {
      return Colors.orange; // Day is upcoming
    } else if (now.isAfter(day.endTime)) {
      return Colors.red; // Day has ended
    } else {
      return Colors.green; // Day is ongoing
    }
  }
}
