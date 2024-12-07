import 'package:conference_management_system/models/person.dart';
import 'package:conference_management_system/screens/authors/authors_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorsList extends StatelessWidget {
  const AuthorsList({super.key});

  @override
  Widget build(BuildContext context) {
    final authors = Provider.of<List<Person>?>(context);

    if (authors == null) {
      return const Center(
          child: CircularProgressIndicator()); // Loading indicator
    }

    if (authors.isEmpty) {
      return const Center(child: Text("No authors found"));
    }

    // Sort authors by name in ascending order
    final sortedAuthors = List<Person>.from(authors)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of tiles per row
        crossAxisSpacing: 0.0, // Space between columns
        mainAxisSpacing: 5.0, // Space between rows
        childAspectRatio: 1.5, // Increase the width of each tile
      ),
      itemCount: sortedAuthors.length,
      itemBuilder: (context, index) {
        return AuthorsTile(
          author: sortedAuthors[index],
        );
      },
    );
  }
}
