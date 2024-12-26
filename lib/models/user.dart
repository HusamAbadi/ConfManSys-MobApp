import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String username;
  final List<String> favoritePapers;
  final List<String> reports; // New field to store reports

  AppUser({
    required this.id,
    required this.username,
    required this.favoritePapers,
    required this.reports,
  });

  // Factory method to create an AppUser from Firestore document
factory AppUser.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  return AppUser(
    id: doc.id,
    username: data['username'] ?? 'Guest User',
    favoritePapers: List<String>.from(data['favoritePapers'] ?? []),
    reports: List<String>.from(data['reports'] ?? []), // Handle missing field
  );
}


  // Convert user to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'favoritePapers': favoritePapers,
      'reports': reports, // Include reports in the map
    };
  }
}
