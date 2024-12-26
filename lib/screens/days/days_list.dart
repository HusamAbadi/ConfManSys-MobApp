import 'package:conference_management_system/models/conference.dart';
import 'package:conference_management_system/screens/days/day_tile.dart';
import 'package:flutter/material.dart';
import 'package:conference_management_system/models/day.dart';
import 'package:provider/provider.dart';

class DaysList extends StatelessWidget {
  final Conference? conference;
  final ValueNotifier<double> fontSizeNotifier;

  const DaysList({
    this.conference,
    required this.fontSizeNotifier,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final days = Provider.of<List<Day>?>(context);

    // Show loading indicator while fetching data
    if (days == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show message if there are no days available
    if (days.isEmpty) {
      return const Center(
        child: Text('No days available for this conference.'),
      );
    }

    // Sort the days list based on the date
    days.sort((a, b) => a.date.compareTo(b.date));

    return ListView.builder(
      itemCount: days.length,
      itemBuilder: (context, index) {
        return DayTile(
          day: days[index],
          conference: conference!,
          dayIncrement: index + 1,
          fontSizeNotifier: fontSizeNotifier,
        );
      },
    );
  }
}
