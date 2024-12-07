import 'package:conference_management_system/screens/wrapper.dart';
import 'package:conference_management_system/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conference_management_system/models/user.dart';
import 'package:conference_management_system/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with error handling
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate AuthService outside for better clarity
    final AuthService authService = AuthService();

    return StreamProvider<AppUser?>.value(
      value: authService.userStream,
      initialData: null,
      child: MaterialApp(
        title: 'Conference Management System',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // Define other theme properties here
        ),
        home: const Wrapper(),
        debugShowCheckedModeBanner:
            false, // Hides the debug banner in release mode
      ),
    );
  }
}
