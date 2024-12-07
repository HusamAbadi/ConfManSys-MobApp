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

  // Define a list of button titles and their respective screens
  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Conferences', 'screen': const ConferencesScreen()},
    {'title': 'Authors', 'screen': const AuthorsScreen()},
    {'title': 'Keywords', 'screen': const KeywordsScreen()},
    {'title': 'Favorite Papers', 'screen': const FavoritePapersScreen()},
  ];

  Future<String> _getUsername() async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc.data()?['username'] ?? 'Guest User';
      }
    }
    return 'Guest User';
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Conferences Management System",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: 10),
                FutureBuilder<String>(
                  future: _getUsername(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return Text(
                      "Welcome, ${snapshot.data ?? 'Guest User'}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                _buildMenuButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to build the menu buttons
  Widget _buildMenuButtons(BuildContext context) {
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
              child: Text(item['title']),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Method to show logout confirmation dialog
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
