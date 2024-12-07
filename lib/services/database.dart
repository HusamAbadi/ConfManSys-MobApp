import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conference_management_system/models/conference.dart';
import 'package:conference_management_system/models/day.dart';
import 'package:conference_management_system/models/session.dart';
import 'package:conference_management_system/models/person.dart';
import 'package:conference_management_system/models/paper.dart';
import 'package:conference_management_system/models/keyword.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  //* Collections' References
  final CollectionReference conferencesCollection =
      FirebaseFirestore.instance.collection('conferences');

  final CollectionReference sessionsCollection =
      FirebaseFirestore.instance.collection('sessions');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference papersCollection =
      FirebaseFirestore.instance.collection('papers');

  final CollectionReference keywordsCollection =
      FirebaseFirestore.instance.collection('keywords');

  final CollectionReference personsCollection =
      FirebaseFirestore.instance.collection('persons');

  //* Streams

  Stream<DocumentSnapshot> get users {
    return usersCollection.doc(uid).snapshots();
  }

  Stream<DocumentSnapshot> get papers {
    return papersCollection.doc(uid).snapshots();
  }

  Stream<DocumentSnapshot> get keywords {
    return keywordsCollection.doc(uid).snapshots();
  }

  Stream<DocumentSnapshot> get persons {
    return personsCollection.doc(uid).snapshots();
  }

  //* Conference list from snapshot
  List<Conference> _conferenceListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Conference.fromFirestore(doc);
    }).toList();
  }

  Stream<List<Conference>> get conferences {
    return conferencesCollection.snapshots().map(_conferenceListFromSnapshot);
  }

  // Days list from snapshot
  List<Day> _dayListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Day.fromFirestore(doc);
    }).toList();
  }

  ///* Stream for days sub-collection in a specific conference document
  Stream<List<Day>> daysStream(String conferenceId) {
    return conferencesCollection
        .doc(conferenceId)
        .collection('days')
        .snapshots()
        .map(_dayListFromSnapshot);
  }

  //* Sessions Stream
  Future<List<Session>> fetchSessions(String conferenceId, String dayId) async {
    try {
      print('Fetching sessions for conference: $conferenceId, day: $dayId');

      final DocumentReference dayRef =
          conferencesCollection.doc(conferenceId).collection('days').doc(dayId);

      // First verify the day document exists
      final dayDoc = await dayRef.get();
      if (!dayDoc.exists) {
        print('Day document does not exist');
        return [];
      }

      QuerySnapshot snapshot = await dayRef.collection('sessions').get();

      print('Found ${snapshot.docs.length} session documents');

      if (snapshot.docs.isEmpty) {
        print('No session documents found');
        return [];
      }

      List<Session> sessions = [];
      for (var doc in snapshot.docs) {
        try {
          final session = Session.fromFirestore(doc);
          sessions.add(session);
          print('Successfully parsed session: ${session.title}');
        } catch (e) {
          print('Error parsing session document ${doc.id}: $e');
        }
      }

      return sessions;
    } catch (e) {
      print('Error fetching sessions: $e');
      return [];
    }
  }

  Future<List<Paper>> fetchPapers(List<String> paperIds) async {
    try {
      List<Future<Paper>> futures = paperIds.map((paperId) {
        return papersCollection
            .doc(paperId)
            .get()
            .then((doc) => Paper.fromFirestore(doc));
      }).toList();

      return await Future.wait(futures);
    } catch (e) {
      return [];
    }
  }

  /// Adds a paper to the user's favorite papers list in Firestore.
  ///
  /// If the paper is not already in the list, it is added. Otherwise, the
  /// function does nothing.
  ///
  /// The function returns a Future<void> that resolves when the operation is
  /// complete. If an error occurs during the operation, the Future is rejected
  /// with the error.
  Future<void> addFavoritePaper(String paperId) async {
    try {
      final userDoc = usersCollection
          .doc(uid); // Assuming 'uid' is the user's unique identifier

      // Get the current list of favorite papers
      DocumentSnapshot userSnapshot = await userDoc.get();
      List<dynamic> favoritePapers =
          (userSnapshot.data() as Map<String, dynamic>)['favoritePapers'] ?? [];

      // Add the paperId if it's not already in the list
      if (!favoritePapers.contains(paperId)) {
        favoritePapers.add(paperId);

        // Update the user's document with the new favorite papers list
        await userDoc.update({
          'favoritePapers': favoritePapers,
        });
      }
    } catch (e) {
      print("Error adding favorite paper: $e");
    }
  }

  Future<List<Paper>> fetchPapersByAuthor(String authorId) async {
    List<Paper> papers = [];
    QuerySnapshot querySnapshot =
        await papersCollection.where('authors', arrayContains: authorId).get();

    papers = querySnapshot.docs.map((doc) => Paper.fromFirestore(doc)).toList();

    return papers;
  }

  Future<List<Paper>> fetchPapersByKeyword(String keywordId) async {
    List<Paper> papers = [];

    QuerySnapshot querySnapshot = await papersCollection
        .where('keywords', arrayContains: keywordId)
        .get();

    papers = querySnapshot.docs.map((doc) => Paper.fromFirestore(doc)).toList();

    return papers;
  }

  Future<List<Person>> fetchAuthorsByPaper(List<String> personIds) async {
    try {
      List<Future<Person>> futures = personIds.map((personId) {
        return personsCollection
            .doc(personId)
            .get()
            .then((doc) => Person.fromFirestore(doc));
      }).toList();

      return await Future.wait(futures);
    } catch (e) {
      return [];
    }
  }

  Future<List<Person>> fetchAllAuthors() async {
    return await fetchDocuments<Person>(
        personsCollection, Person.fromFirestore);
  }

  Future<List<Keyword>> fetchKeywords(List<String> keywordIds) async {
    try {
      List<Future<Keyword>> futures = keywordIds.map((keywordId) {
        return keywordsCollection
            .doc(keywordId)
            .get()
            .then((doc) => Keyword.fromFirestore(doc));
      }).toList();

      return await Future.wait(futures);
    } catch (e) {
      return [];
    }
  }

  Future<List<Keyword>> fetchAllKeywords() async {
    return await fetchDocuments<Keyword>(
        keywordsCollection, Keyword.fromFirestore);
  }

  Future<List<Paper>> fetchFavoritePapers() async {
    try {
      final userDoc = await usersCollection.doc(uid).get();
      final List<dynamic> favoritePaperIds =
          userDoc.get('favoritePapers') ?? [];

      // Use Future.wait to fetch all papers in parallel while maintaining order
      final futures = favoritePaperIds.map((paperId) async {
        final paperDoc = await papersCollection.doc(paperId).get();
        if (paperDoc.exists) {
          return Paper.fromFirestore(paperDoc);
        }
        return null;
      }).toList();

      final papers = await Future.wait(futures);
      // Filter out any null values (papers that weren't found) while maintaining order
      return papers.whereType<Paper>().toList();
    } catch (e) {
      print('Error fetching favorite papers: $e');
      return [];
    }
  }

  //* Generic Fetch Method
  Future<List<T>> fetchDocuments<T>(CollectionReference collection,
      T Function(DocumentSnapshot doc) fromFirestore) async {
    try {
      print('Fetching documents from ${collection.path}'); // Debug log
      QuerySnapshot snapshot = await collection.get();
      print(
          'Found ${snapshot.docs.length} documents in ${collection.path}'); // Debug log

      List<T> results = [];
      for (var doc in snapshot.docs) {
        try {
          results.add(fromFirestore(doc));
        } catch (e) {
          print(
              'Error parsing document ${doc.id}: $e'); // Debug log for parsing errors
        }
      }

      return results;
    } catch (e) {
      print(
          'Error fetching documents from ${collection.path}: $e'); // Debug log for fetch errors
      return [];
    }
  }

  //* Fetch Methods for New Models
  Future<List<Person>> fetchChairPersons(List<String> chairPersonsIds) async {
    try {
      List<Future<Person>> futures = chairPersonsIds.map((chairPersonId) {
        return personsCollection
            .doc(chairPersonId)
            .get()
            .then((doc) => Person.fromFirestore(doc));
      }).toList();

      return await Future.wait(futures);
    } catch (e) {
      return [];
    }
  }
}
