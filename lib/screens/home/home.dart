import 'package:conference_management_system/screens/conferences/conferences_screen.dart';
import 'package:conference_management_system/screens/authors/authors_screen.dart';
import 'package:conference_management_system/screens/keywords/keywords_screen.dart';
import 'package:conference_management_system/screens/favorite_papers/favorite_papers_screen.dart';
import 'package:conference_management_system/services/auth.dart';
import 'package:conference_management_system/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Conferences', 'screen': ConferencesScreen()},
    {'title': 'Authors', 'screen': const AuthorsScreen()},
    {'title': 'Keywords', 'screen': const KeywordsScreen()},
    {'title': 'Favorite Papers', 'screen': const FavoritePapersScreen()},
  ];

  final ValueNotifier<double> _fontSizeNotifier = ValueNotifier(16.0);
  final double _minFontSize = 12.0; // Minimum font size
  final double _maxFontSize = 30.0; // Optional maximum font size

  Future<String> _getUsername() async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      print("User is logged in with UID: ${user.uid}");
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          print("User document data: ${doc.data()}");
          return doc.data()?['username'] ?? 'Guest User';
        } else {
          print("User document does not exist in Firestore.");
          // Optionally, create the document here if it doesn't exist
          await _firestore.collection('users').doc(user.uid).set({
            'username': 'Guest User',
            'favoritePapers': [],
            'reports': [],
          });
          print("Created user document for UID: ${user.uid}");
          return 'Guest User';
        }
      } catch (e) {
        print("Error fetching user document: $e");
        return 'Guest User';
      }
    } else {
      print("No user is currently logged in.");
      return 'Guest User';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: bodyBackgroundColor,
        appBar: AppBar(
          title: const Text("Home Screen"),
          titleTextStyle: titleFontStyle,
          backgroundColor: appBarColor,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.text_increase),
              onPressed: () {
                _fontSizeNotifier.value = (_fontSizeNotifier.value + 2)
                    .clamp(_minFontSize, _maxFontSize);
              },
              tooltip: 'Increase Font Size',
            ),
            IconButton(
              icon: const Icon(Icons.text_decrease),
              onPressed: () {
                _fontSizeNotifier.value = (_fontSizeNotifier.value - 2)
                    .clamp(_minFontSize, _maxFontSize);
              },
              tooltip: 'Decrease Font Size',
            ),
            TextButton.icon(
              icon: const Icon(Icons.person),
              label: const Text("Logout"),
              onPressed: () async {
                bool? confirmLogout = await _showLogoutDialog(context);
                if (confirmLogout ?? false) {
                  await _auth.signOut();
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ValueListenableBuilder<double>(
              valueListenable: _fontSizeNotifier,
              builder: (context, fontSize, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Conferences Management System",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize + 6,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<String>(
                      future: _getUsername(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text(
                            "Error loading username",
                            style: TextStyle(color: Colors.red),
                          );
                        } else if (snapshot.hasData) {
                          return Text(
                            "Welcome, ${snapshot.data}",
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          );
                        } else {
                          return Text(
                            "Welcome, Guest User",
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildMenuButtons(context, fontSize),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButtons(BuildContext context, double fontSize) {
    return Column(
      children: _menuItems.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => item['screen']),
                );
              },
              child: Text(
                item['title'],
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<bool?> _showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
