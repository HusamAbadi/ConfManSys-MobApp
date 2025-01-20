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

  final CollectionReference reportsCollection =
      FirebaseFirestore.instance.collection('reports');

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

  Future<void> addReport(String description) async {
    final userDoc = usersCollection.doc(uid);
    try {
      // First get the user document
      final userData = await userDoc.get();
      await reportsCollection.add({
        'username': userData.get('username'),
        'userId': uid,
        'description': description,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding report: $e');
      throw e;
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

  /// Checks if a paper is already in the user's favorite papers list.
  ///
  /// Returns a Future<bool> that resolves to true if the paper is in the favorites list,
  /// false otherwise.
  Future<bool> isPaperInFavorites(String paperId) async {
    try {
      final userDoc = usersCollection.doc(uid);
      DocumentSnapshot userSnapshot = await userDoc.get();
      
      if (!userSnapshot.exists) {
        return false;
      }

      final userData = userSnapshot.data() as Map<String, dynamic>;
      final List<dynamic> favoritePapers = userData['favoritePapers'] ?? [];
      
      return favoritePapers.contains(paperId);
    } catch (e) {
      print("Error checking favorite paper: $e");
      return false;
    }
  }

  /// Removes a paper from the user's favorite papers list in Firestore.
  ///
  /// If the paper is in the list, it is removed. Otherwise, the function does nothing.
  ///
  /// The function returns a Future<void> that resolves when the operation is complete.
  /// If an error occurs during the operation, the Future is rejected with the error.
  Future<void> removeFavoritePaper(String paperId) async {
    try {
      final userDoc = usersCollection.doc(uid);
      
      // Get the current list of favorite papers
      DocumentSnapshot userSnapshot = await userDoc.get();
      List<dynamic> favoritePapers = (userSnapshot.data() as Map<String, dynamic>)['favoritePapers'] ?? [];
      
      // Remove the paperId if it exists in the list
      favoritePapers.remove(paperId);
      
      // Update the user's document with the new favorite papers list
      await userDoc.update({
        'favoritePapers': favoritePapers,
      });
    } catch (e) {
      print("Error removing favorite paper: $e");
      throw e; // Re-throw to handle in UI
    }
  }

  /// Returns a stream of favorite papers for the current user
  Stream<List<Paper>> streamFavoritePapers() async* {
    try {
      // Listen to changes in the user document
      Stream<DocumentSnapshot> userStream = usersCollection.doc(uid).snapshots();
      
      await for (DocumentSnapshot userDoc in userStream) {
        if (!userDoc.exists) {
          yield [];
          continue;
        }

        final userData = userDoc.data() as Map<String, dynamic>;
        final List<dynamic> favoritePaperIds = userData['favoritePapers'] ?? [];
        
        if (favoritePaperIds.isEmpty) {
          yield [];
          continue;
        }

        // Fetch all papers that are in the favorites list
        List<Paper> papers = [];
        for (String paperId in favoritePaperIds) {
          try {
            DocumentSnapshot paperDoc = await papersCollection.doc(paperId).get();
            if (paperDoc.exists) {
              papers.add(Paper.fromFirestore(paperDoc));
            }
          } catch (e) {
            print('Error fetching paper $paperId: $e');
          }
        }
        
        yield papers;
      }
    } catch (e) {
      print('Error in streamFavoritePapers: $e');
      yield [];
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
