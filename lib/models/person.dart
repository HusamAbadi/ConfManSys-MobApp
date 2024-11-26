import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  final String id; // Unique identifier for the person
  final String name; // Name of the person
  final List<String>
      sessionsPresenting; // References to sessions the person is presenting
  final List<String> papers; // References to papers authored by the person

  Person({
    required this.id,
    required this.name,
    required this.sessionsPresenting,
    required this.papers,
  });

  // Factory method to create a Person from Firestore document
  factory Person.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Person(
      id: doc.id, // Get the document ID
      name: data['name'] ?? '', // Default to empty string if name is null
      sessionsPresenting: List<String>.from(
          data['sessionsPresenting'] ?? []), // Convert to list of strings
      papers:
          List<String>.from(data['papers'] ?? []), // Convert to list of strings
    );
  }

  // Static method to convert a list of Firestore documents to a list of Person objects
  static List<Person> fromQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => Person.fromFirestore(doc)).toList();
  }

  // Static method to fetch all persons from Firestore
  static Future<List<Person>> fetchAllPersons() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('persons').get();
      return fromQuerySnapshot(
          snapshot); // Convert the snapshot to a list of Person objects
    } catch (e) {
      return []; // Return an empty list in case of an error
    }
  }
}
