  import 'package:cloud_firestore/cloud_firestore.dart';

  class Session {
    final String id; // Unique identifier for the session
    final String title; // Title of the session
    final String description; // Description of the session
    final DateTime startTime; // Start time of the session
    final DateTime endTime; // End time of the session
    final String location; // Location of the session
    final bool isBreak; // Indicates if the session is a break
    final List<String>
        papers; // References to papers associated with this session
    final List<String>
        chairPersons; // References to chairpersons for this session

    Session({
      required this.id,
      required this.title,
      required this.description,
      required this.startTime,
      required this.endTime,
      required this.location,
      required this.isBreak,
      required this.papers,
      required this.chairPersons,
    });

    // Factory method to create a Session from Firestore document
    factory Session.fromFirestore(DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      print("sessoi");
      print(data);
      return Session(
        id: doc.id, // Get the document ID
        title: data['title'] ?? '', // Default to empty string if title is null
        description: data['description'] ??
            '', // Default to empty string if description is null
        startTime: (data['startTime'] as Timestamp)
            .toDate(), // Convert Firestore Timestamp to DateTime
        endTime: (data['endTime'] as Timestamp)
            .toDate(), // Convert Firestore Timestamp to DateTime
        location:
            data['location'] ?? '', // Default to empty string if location is null
        isBreak: data['isBreak'] ?? false, // Default to false if isBreak is null
        papers:
            List<String>.from(data['papers'] ?? []), // Convert to list of strings
        chairPersons: List<String>.from(
            data['chairPersons'] ?? []), // Convert to list of strings
      );
    }
  }
