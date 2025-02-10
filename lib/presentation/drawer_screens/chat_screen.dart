import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/presentation/components/constants.dart';
import 'package:per_rat/presentation/components/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String recipientId;

  const ChatScreen({
    super.key,
    required this.recipientId,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final User user = FirebaseAuth.instance.currentUser!;
  String? chatId;
  String recName = '';
  bool isFriend = false;

  @override
  void initState() {
    super.initState();
    _setChatId();
    setRecipientName();
    _checkIfFriend();
  }

  Future<void> _setChatId() async {
    var conversationQuery = await FirebaseFirestore.instance
        .collection('conversations')
        .where('participants', arrayContains: user.uid)
        .get();

    for (var doc in conversationQuery.docs) {
      var participants = doc['participants'] as List<dynamic>;
      if (participants.contains(widget.recipientId)) {
        setState(() {
          chatId = doc.id;
        });
        return;
      }
    }

    // If conversation does not exist, set chatId to null
    setState(() {
      chatId = null;
    });
  }

  Future<void> _checkIfFriend() async {
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    var userData = userDoc.data() as Map<String, dynamic>;
    var friends = userData['friends'] as List<dynamic>;

    setState(() {
      isFriend = friends.contains(widget.recipientId);
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    if (chatId == null) {
      // Create a new conversation document if it doesn't exist
      var newChatDoc =
          await FirebaseFirestore.instance.collection('conversations').add({
        'participants': [user.uid, widget.recipientId],
      });
      chatId = newChatDoc.id;
    }

    var message = {
      'text': _messageController.text.trim(),
      'senderId': user.uid,
      'recipientId': widget.recipientId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('conversations')
        .doc(chatId)
        .collection('messages')
        .add(message);

    _messageController.clear();
  }
  //   FirebaseFirestore.instance
  //       .collection('conversations/${widget.chatId}/messages')
  //       .add({
  //     'senderId': user.uid,
  //     'text': _controller.text,
  //     'timestamp': FieldValue.serverTimestamp(),
  //   });
  //   _controller.clear();
  // }

  void setRecipientName() async {
    String recipientName = await getRecipientName(
        widget.recipientId); // Use await to get the actual String
    setState(() {
      recName = recipientName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          recName,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatId == null
                ? Center(
                    child: Text(
                    '...',
                    style: TextStyle(color: Color.fromARGB(255, 63, 208, 94)),
                  ))
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('conversations')
                        .doc(chatId)
                        .collection('messages')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      var messages = snapshot.data!.docs;

                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (ctx, index) => MessageBubble(
                          messages[index]['text'],
                          messages[index]['senderId'] == user.uid,
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'Send a message...'),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: const Color.fromARGB(255, 149, 143, 158),
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
