import 'package:conference_management_system/models/conference.dart';
import 'package:conference_management_system/screens/conferences/conference_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConferencesList extends StatefulWidget {
  const ConferencesList({super.key});

  @override
  State<ConferencesList> createState() => _ConferencesListState();
}

class _ConferencesListState extends State<ConferencesList> {
  @override
  Widget build(BuildContext context) {
    final conferences = Provider.of<List<Conference>?>(context);

    // Display a loading indicator while data is being fetched
    if (conferences == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Display a message if there are no conferences available
    if (conferences.isEmpty) {
      return const Center(
        child: Text('No conferences available'),
      );
    }

    // Sort the conferences by startDate
    conferences.sort((a, b) => a.startDate.compareTo(b.startDate));

    return ListView.builder(
      itemCount: conferences.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ConferenceTile(conference: conferences[index]),
        );
      },
    );
  }
}
