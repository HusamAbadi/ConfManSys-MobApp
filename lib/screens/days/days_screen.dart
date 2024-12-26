import 'package:conference_management_system/models/conference.dart';
import 'package:conference_management_system/models/day.dart';
import 'package:conference_management_system/screens/days/days_list.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:conference_management_system/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:conference_management_system/models/conference.dart';
import 'package:conference_management_system/models/day.dart';
import 'package:conference_management_system/screens/days/days_list.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:conference_management_system/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conference_management_system/shared/custom_app_bar.dart'; // Import CustomAppBar

class DaysScreen extends StatelessWidget {
  final Conference conference;

  const DaysScreen({super.key, required this.conference});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> fontSizeNotifier =
        ValueNotifier(16.0); // Font size notifier

    return StreamProvider<List<Day>?>.value(
      value: DatabaseService(uid: 'uid').daysStream(conference.id),
      initialData: null,
      child: Scaffold(
        backgroundColor: bodyBackgroundColor,
        appBar: CustomAppBar(
          title: "Back to Conferences Screen",
          fontSizeNotifier: fontSizeNotifier,
          showBackButton: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              Center(
                child: ValueListenableBuilder<double>(
                  valueListenable: fontSizeNotifier,
                  builder: (context, fontSize, _) {
                    return Column(
                      children: [
                        Text(
                          conference.name,
                          style: titleFontStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize + 2,
                          ),
                        ),
                        Text(
                          conference.location,
                          style: TextStyle(fontSize: fontSize),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 30.0),
              Expanded(
                child: DaysList(
                  conference: conference,
                  fontSizeNotifier: fontSizeNotifier,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
