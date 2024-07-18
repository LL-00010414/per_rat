// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ChatChanged extends StatefulWidget {
//   final String chatId;
//   final String recipientId;

//   ChatChanged({required this.chatId, required this.recipientId});

//   @override
//   _ChatChangedState createState() => _ChatChangedState();
// }

// class _ChatChangedState extends State<ChatChanged> {
//   final TextEditingController _messageController = TextEditingController();
//   final user = FirebaseAuth.instance.currentUser!;

//   Future<void> sendMessage() async {
//     if (_messageController.text.trim().isEmpty) {
//       return;
//     }
//     var message = {
//       'text': _messageController.text.trim(),
//       'senderId': user.uid,
//       'recipientId': widget.recipientId,
//       'timestamp': FieldValue.serverTimestamp(),
//     };

//     await FirebaseFirestore.instance
//         .collection('conversations')
//         .doc(widget.chatId)
//         .collection('messages')
//         .add(message);

//     _messageController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('conversations')
//                   .doc(widget.chatId)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 var messages = snapshot.data!.docs;

//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     var message = messages[index];
//                     var isSender = message['senderId'] == user.uid;
//                     return ListTile(
//                       title: Align(
//                         alignment: isSender
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Container(
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: isSender ? Colors.blue : Colors.grey,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Text(
//                             message['text'],
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
