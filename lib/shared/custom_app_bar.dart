import 'package:conference_management_system/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final ValueNotifier<double> fontSizeNotifier;
  final double minFontSize;
  final double maxFontSize;
  final bool showBackButton;
  final List<Widget>? actions;

  CustomAppBar({
    required this.title,
    required this.fontSizeNotifier,
    this.minFontSize = 12.0,
    this.maxFontSize = 30.0,
    this.showBackButton = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.amber[400],
      automaticallyImplyLeading: showBackButton,
      title: ValueListenableBuilder<double>(
        valueListenable: fontSizeNotifier,
        builder: (context, fontSize, child) {
          return Text(
            title,
            style: TextStyle(fontSize: fontSize),
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.text_increase),
          onPressed: () {
            fontSizeNotifier.value =
                (fontSizeNotifier.value + 2).clamp(minFontSize, maxFontSize);
          },
          tooltip: 'Increase Font Size',
        ),
        IconButton(
          icon: const Icon(Icons.text_decrease),
          onPressed: () {
            fontSizeNotifier.value =
                (fontSizeNotifier.value - 2).clamp(minFontSize, maxFontSize);
          },
          tooltip: 'Decrease Font Size',
        ),
        IconButton(
          icon: const Icon(Icons.report),
          onPressed: () => _showReportDialog(context),
          tooltip: 'Submit Report',
        ),
        if (actions != null) ...actions!,
      ],
    );
  }

  void _showReportDialog(BuildContext context) {
    final TextEditingController reportController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Submit Report'),
          content: TextField(
            controller: reportController,
            decoration: const InputDecoration(
              hintText: 'Enter your report or bug report here',
            ),
            maxLines: 5,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final report = reportController.text.trim();
                if (report.isNotEmpty) {
                  try {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User not logged in.')),
                      );
                      return;
                    }

                    final DatabaseService dbService =
                        DatabaseService(uid: user.uid);

                    // Add the report to Firestore
                    await dbService.addReport(report);

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Thank you for your report!')),
                    );

                    Navigator.of(dialogContext).pop(); // Close the dialog
                  } catch (e) {
                    // Handle error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to submit report: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Please enter a report before submitting.')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
