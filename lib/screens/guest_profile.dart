import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GuestProfile extends StatefulWidget {
  const GuestProfile({
    super.key,
    required this.guestUserId,
  });

  final String guestUserId;

  @override
  _GuestProfileState createState() => _GuestProfileState();
}

class _GuestProfileState extends State<GuestProfile> {
  //final user = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.guestUserId)
          .get();

      setState(() {
        userData = userDoc.data() as Map<String, dynamic>?;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(userData?['username'] ?? 'Profile'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.edit),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileHeader(context),
                  SizedBox(height: 20),
                  _buildUserInfo(context),
                  SizedBox(height: 20),
                  _buildBioSection(context),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
            userData!['image_url'] ??
                'https://cdn2.iconfinder.com/data/icons/ios-7-icons/50/user_male4-1024.png',
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userData!['username'] ?? '-',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                userData!['email'] ?? 'Email is not indicated',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Column(
      children: [
        _buildUserInfoRow(
            'Last Online',
            userData!['status'] == 'online'
                ? 'now'
                : _formatTimestamp(userData!['last_online'])),
        _buildUserInfoRow('Gender', userData!['gender'] ?? '-'),
        _buildUserInfoRow(
          'Birthday',
          userData!['birthday'] != null
              ? _formatTimestamp(userData!['birthday'])
              : '-',
        ),
        _buildUserInfoRow('Location', userData!['location'] ?? '-'),
        _buildUserInfoRow(
          'Joined',
          userData!['joinedTime'] != null
              ? DateFormat('MMM dd, yyyy')
                  .format((userData!['joinedTime'] as Timestamp).toDate())
              : 'N/A',
        ),
      ],
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBioSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Bio',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.purple[200],
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            userData!['bio'] != null
                ? userData!['bio'].join(' ')
                : 'No bio added',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return "${date.year}-${date.month}-${date.day}";
  }
}
