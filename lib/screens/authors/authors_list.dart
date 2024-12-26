import 'package:conference_management_system/models/person.dart';
import 'package:conference_management_system/screens/authors/authors_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorsList extends StatelessWidget {
  final ValueNotifier<double> fontSizeNotifier;

  const AuthorsList({super.key, required this.fontSizeNotifier});

  @override
  Widget build(BuildContext context) {
    final authors = Provider.of<List<Person>?>(context);

    if (authors == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (authors.isEmpty) {
      return const Center(child: Text("No authors found"));
    }

    final sortedAuthors = List<Person>.from(authors)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 5.0,
        childAspectRatio: 1.5,
      ),
      itemCount: sortedAuthors.length,
      itemBuilder: (context, index) {
        return AuthorsTile(
          author: sortedAuthors[index],
          fontSizeNotifier: fontSizeNotifier,
        );
      },
    );
  }
}
