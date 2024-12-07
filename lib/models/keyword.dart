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
      
      // Handle papers array - filter out null values and log the process
      List<String> papersList = [];
      if (data['papers'] != null) {
        final rawPapers = data['papers'] as List;
        print('Raw papers for keyword ${doc.id}: $rawPapers'); // Debug log
        
        papersList = rawPapers
            .where((item) => item != null)  // Filter out null values
            .map((item) => item.toString()) // Convert to String
            .toList();
            
        print('Processed papers for keyword ${doc.id}: $papersList'); // Debug log
      } else {
        print('No papers array found for keyword ${doc.id}'); // Debug log
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
