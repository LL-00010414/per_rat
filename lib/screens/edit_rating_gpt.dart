// import 'package:flutter/material.dart';

// class EditRatingGpt extends StatelessWidget {
//   final String animeTitle = "Kono Subarashii Sekai ni Shukufuku wo! 3";
//   final String status = "Completed";
//   final int progress = 0;
//   final int score = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           animeTitle,
//           overflow: TextOverflow.ellipsis,
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: () {
//               // Save action
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               animeTitle,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.amberAccent,
//               ),
//             ),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 Text(
//                   'Status:',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 Text(
//                   status,
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.purpleAccent,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Wrap(
//               spacing: 10,
//               children: [
//                 _buildStatusButton(context, "Completed"),
//                 _buildStatusButton(context, "Watching"),
//                 _buildStatusButton(context, "Plan to Watch"),
//                 _buildStatusButton(context, "On Hold"),
//                 _buildStatusButton(context, "Dropped"),
//               ],
//             ),
//             SizedBox(height: 16),
//             _buildProgressAndScoreSection("Progress", progress, 10),
//             SizedBox(height: 16),
//             _buildProgressAndScoreSection("Score", score, 5),
//             Spacer(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                   ),
//                   onPressed: () {
//                     // Submit action
//                   },
//                   child: Text('Submit'),
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                   ),
//                   onPressed: () {
//                     // Delete action
//                   },
//                   child: Text('Delete'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusButton(BuildContext context, String label) {
//     return OutlinedButton(
//       style: OutlinedButton.styleFrom(
//         side: BorderSide(
//           color: Colors.white,
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       onPressed: () {
//         // Handle status change
//       },
//       child: Text(
//         label,
//         style: TextStyle(color: Colors.white),
//       ),
//     );
//   }

//   Widget _buildProgressAndScoreSection(String title, int value, int maxValue) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         SizedBox(height: 8),
//         Wrap(
//           spacing: 10,
//           children: List.generate(maxValue, (index) {
//             return _buildProgressOrScoreButton(index + 1, value == index + 1);
//           }),
//         ),
//       ],
//     );
//   }

//   Widget _buildProgressOrScoreButton(int number, bool isSelected) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: isSelected ? Colors.blueAccent : Colors.grey[800],
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//       ),
//       onPressed: () {
//         // Handle progress or score selection
//       },
//       child: Text(
//         number.toString(),
//         style: TextStyle(fontSize: 18),
//       ),
//     );
//   }
// }
