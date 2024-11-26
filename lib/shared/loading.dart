import 'package:conference_management_system/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: bodyBackgroundColor,
        child: const Center(
          child: SpinKitWave(
            color: Colors.amber,
            size: 50.0,
          ),
        ));
  }
}
