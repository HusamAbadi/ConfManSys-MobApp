// import 'package:conference_management_system/models/conference.dart';
// import 'package:conference_management_system/models/session.dart';
// import 'package:conference_management_system/screens/sessions/session_tile.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class SessionTimeline extends StatelessWidget {
//   final Conference conference;
//   final List<Session> sessions;
//   final DateTime timelineStart =
//       DateTime(2024, 12, 2, 7, 0); // Timeline starts at 7 AM
//   final DateTime timelineEnd =
//       DateTime(2024, 12, 2, 17, 0); // Timeline ends at 5 PM

//   SessionTimeline({
//     super.key,
//     required this.conference,
//     required this.sessions,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Sessions Timeline"),
//       ),
//       body: Stack(
//         children: [
//           // Timeline
//           Positioned.fill(
//             child: CustomPaint(
//               painter: TimelinePainter(
//                 startTime: timelineStart,
//                 endTime: timelineEnd,
//               ),
//             ),
//           ),
//           // Sessions
//           ListView.builder(
//             itemCount: sessions.length,
//             itemBuilder: (context, index) {
//               final session = sessions[index];

//               // Calculate vertical position based on start and end times
//               final double topPosition =
//                   _calculateTopPosition(session.startTime);
//               final double height =
//                   _calculateHeight(session.startTime, session.endTime);

//               return Positioned(
//                 top: topPosition,
//                 left: 100.0, // Adjust to the right of the timeline
//                 width: MediaQuery.of(context).size.width - 120,
//                 height: height,
//                 child: SessionTile(
//                   session: session,
//                   conference: conference,
//                   dayIncrement: 0,
//                   sessionIncrement: index + 1,
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   // Calculate the top position in the timeline
//   double _calculateTopPosition(DateTime sessionTime) {
//     final totalMinutes = timelineEnd.difference(timelineStart).inMinutes;
//     final sessionMinutes = sessionTime.difference(timelineStart).inMinutes;
//     return (sessionMinutes / totalMinutes) *
//         MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;
//   }

//   // Calculate the height of a session tile
//   double _calculateHeight(DateTime startTime, DateTime endTime) {
//     final totalMinutes = endTime.difference(startTime).inMinutes;
//     return (totalMinutes / 60) * 100; // Scale height (adjust as needed)
//   }
// }

// class TimelinePainter extends CustomPainter {
//   final DateTime startTime;
//   final DateTime endTime;

//   TimelinePainter({required this.startTime, required this.endTime});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.grey
//       ..strokeWidth = 2.0;

//     final startY = 0.0;
//     final endY = size.height;

//     // Draw vertical timeline line
//     canvas.drawLine(Offset(50, startY), Offset(50, endY), paint);

//     // Draw time markers
//     final totalMinutes = endTime.difference(startTime).inMinutes;
//     for (int i = 0; i <= totalMinutes; i += 60) {
//       final markerTime = startTime.add(Duration(minutes: i));
//       final markerY = (i / totalMinutes) * size.height;

//       final textPainter = TextPainter(
//         text: TextSpan(
//           text: DateFormat('h a').format(markerTime),
//           style: const TextStyle(color: Colors.black, fontSize: 12),
//         ),
//         // textDirection: TextDirection.LTR,
//       );
//       textPainter.layout();
//       textPainter.paint(canvas, Offset(10, markerY - textPainter.height / 2));
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
