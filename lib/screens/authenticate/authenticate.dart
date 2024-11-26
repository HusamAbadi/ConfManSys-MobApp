import 'package:conference_management_system/screens/authenticate/register.dart';
import 'package:conference_management_system/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Authentiacte extends StatefulWidget {
  const Authentiacte({super.key});

  @override
  State<Authentiacte> createState() => _AuthentiacteState();
}

class _AuthentiacteState extends State<Authentiacte> {
  bool showSignIn = true;

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
