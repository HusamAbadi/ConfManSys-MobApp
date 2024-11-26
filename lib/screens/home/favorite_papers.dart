// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:conference_management_system/services/database.dart';
// import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:conference_management_system/screens/home/favorite_papers_list.dart';

// class FavoritePapers extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<QuerySnapshot?>.value(
//         value: DatabaseService(uid: 'uid').conferences(),
//         initialData: null,
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Favorite Papers'),
//           ),
//           body: const Column(
//             children: [
//               Center(
//                 child: Text(
//                   'Your Favorite Papers',
//                   style: TextStyle(fontSize: 24),
//                 ),
//               ),
//               FavoritePapersList(),
//             ],
//           ),
//         ));
//   }
// }
