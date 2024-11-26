import 'package:cloud_firestore/cloud_firestore.dart';

class Keyword {
  final String id;
  final String name;
  final List<String> papers; // References to papers related to this keyword

  Keyword({
    required this.id,
    required this.name,
    required this.papers,
  });

  // Factory method to create a Keyword from a Firestore document
  factory Keyword.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Keyword(
      id: doc.id,
      name: data['name'] ??
          '', // Provide a default empty string if 'name' is null
      papers: List<String>.from(data['papers'] ??
          []), // Convert the 'papers' field to a list of strings
    );
  }
}
