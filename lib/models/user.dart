import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final List<DocumentReference> favoritePapers; // References to favorite papers

  AppUser({
    required this.id,
    required this.favoritePapers,
  });

  // Factory method to create a AppUser from Firestore document
  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      favoritePapers:
          List<DocumentReference>.from(data['favoritePapers'] ?? []),
    );
  }
}
