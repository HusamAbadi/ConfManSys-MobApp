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
    try {
      final data = doc.data() as Map<String, dynamic>;
      print('Parsing keyword document ${doc.id}: ${data.toString()}'); // Debug log
      
      // Handle papers array - filter out null values
      List<String> papersList = [];
      if (data['papers'] != null) {
        papersList = (data['papers'] as List)
            .where((item) => item != null)  // Filter out null values
            .map((item) => item.toString()) // Convert to String
            .toList();
      }

      return Keyword(
        id: doc.id,
        name: data['name'] ?? '', // Provide a default empty string if 'name' is null
        papers: papersList,
      );
    } catch (e) {
      print('Error parsing keyword document ${doc.id}: $e'); // Debug log
      rethrow; // Re-throw the error to be caught by fetchDocuments
    }
  }
}
