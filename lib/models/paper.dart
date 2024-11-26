import 'package:cloud_firestore/cloud_firestore.dart';

class Paper {
  final String id;
  final String title;
  final String abstract;
  final List<String> authors; // List of author IDs or names
  final List<String> keywords; // List of keyword IDs or names

  Paper({
    required this.id,
    required this.title,
    required this.abstract,
    required this.authors,
    required this.keywords,
  });

  // Factory method to create a Paper from a Firestore document
  factory Paper.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Paper(
      id: doc.id,
      title: data['title'] ?? '', // Default to empty string if title is null
      abstract:
          data['abstract'] ?? '', // Default to empty string if abstract is null
      authors: List<String>.from(
          data['authors'] ?? []), // Convert authors to a list of strings
      keywords: List<String>.from(
          data['keywords'] ?? []), // Convert keywords to a list of strings
    );
  }
}
