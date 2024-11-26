import 'package:cloud_firestore/cloud_firestore.dart';

class Conference {
  final String id;
  final String name;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final List<DocumentReference> days;

  Conference({
    required this.id,
    required this.name,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.days,
  });

  // Factory method to create a Conference object from Firestore document
  factory Conference.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Conference(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      days: List<DocumentReference>.from(data['days'] ?? []),
    );
  }

  // Static method to get a list of conferences from Firestore snapshots
  static List<Conference> fromQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Conference.fromFirestore(doc);
    }).toList();
  }
}
