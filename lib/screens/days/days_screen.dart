import 'package:conference_management_system/models/conference.dart';
import 'package:conference_management_system/models/day.dart';
import 'package:conference_management_system/screens/days/days_list.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:conference_management_system/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DaysScreen extends StatelessWidget {
  final Conference conference;

  const DaysScreen({super.key, required this.conference});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Day>?>.value(
      value: DatabaseService(uid: 'uid')
          .daysStream(conference.id), // Provide conference ID
      initialData: null,
      child: Scaffold(
        backgroundColor: bodyBackgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text(
            "Back to Conferences Screen",
          ),
          titleTextStyle: titleFontStyle,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              Center(
                child: Text(
                  conference.name,
                  style: titleFontStyle.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30.0),
              Expanded(
                child: DaysList(
                    conference: conference), // Pass the conference to DaysList
              ),
            ],
          ),
        ),
      ),
    );
  }
}
