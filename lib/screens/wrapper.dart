import 'package:conference_management_system/models/user.dart';
import 'package:conference_management_system/screens/authenticate/authenticate.dart';
import 'package:conference_management_system/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    //* return either home or authenticate widget
    if (user == null) {
      return const Authentiacte();
    } else {
      return Home();
    }
  }
}
