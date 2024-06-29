import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:per_rat/user_profile_screens/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
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
          .doc(user.uid)
          .get();

      setState(() {
        userData = userDoc.data() as Map<String, dynamic>?;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _navigateToEditProfile() async {
    // Navigate to EditProfileScreen and wait for result
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EditProfileScreen(),
      ),
    );

    // If result is true, refresh user data
    if (result == true) {
      _fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(userData?['username'] ?? 'Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _navigateToEditProfile();
            },
          ),
        ],
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
                userData!['email'] ?? user.email,
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
            DateFormat('MMM dd, yyyy')
                .format(user.metadata.creationTime!)
                .toString()),
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
