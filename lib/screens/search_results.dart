// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// class SearchResultsScreen extends StatefulWidget {
//   const SearchResultsScreen({super.key});

//   @override
//   State<SearchResultsScreen> createState() => _SearchResultsScreenState();
// }

// class _SearchResultsScreenState extends State<SearchResultsScreen> {
//   final searchItem = ;
//   var searchName = "";
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: SizedBox(
//           height: 40,
//           child: TextField(
//             onChanged: (value) {
//               setState(() {
//                 searchName = value;
//               });
//             },
//             decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none),
//                 contentPadding:
//                     EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//                 filled: true,
//                 fillColor: Color.fromARGB(255, 39, 39, 39),
//                 hintText: 'Search',
//                 hintStyle: TextStyle(color: Colors.grey),
//                 prefixIcon: Icon(
//                   Icons.search,
//                   color: Colors.grey,
//                 )),
//           ),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('users')
//               .orderBy('userName')
//               .startAt([searchName]).endAt([searchName + "\uf8ff"]).snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Text('Something went wrong');
//             }

//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Text("Loading");
//             }
//             return ListView.builder(
//                 itemCount: snapshot.data!.docs.length,
//                 itemBuilder: (context, index) {
//                   var data = snapshot.data!.docs[index];
//                   return ListTile(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ProfileView(
//                                   userId: data['id'],
//                                 )),
//                       );
//                     },
//                     leading: CircleAvatar(
//                       radius: 24,
//                       backgroundImage: NetworkImage(data['profileUrl']),
//                     ),
//                     title: Text(data['userName']),
//                     subtitle: Text(data['email']),
//                   );
//                 });
//           }),
//     );
//   }
// }
