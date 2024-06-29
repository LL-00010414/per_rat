import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic>? userData;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  DateTime? _selectedDate;
  String? _gender;
  File? _imageFile;
  final picker = ImagePicker();

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
        _usernameController.text = userData?['username'] ?? '';
        _locationController.text = userData?['location'] ?? '';
        _bioController.text = userData?['bio']?.join(' ') ?? '';
        _selectedDate = userData?['birthday']?.toDate();
        _gender = userData?['gender'];
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _pickImage() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: () {
                    _getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    _getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.uid}.jpg');
      await storageRef.putFile(image);
      final imageUrl = await storageRef.getDownloadURL();

      setState(() {
        userData!['image_url'] = imageUrl;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'image_url': imageUrl,
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _saveProfile() async {
    try {
      if (_imageFile != null) {
        await _uploadImage(_imageFile!);
      }
      //updating other fields
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'username': _usernameController.text,
        'location': _locationController.text,
        'bio': _bioController.text.split(' '),
        'birthday': _selectedDate,
        'gender': _gender,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );

      // Return true to indicate that the profile was updated
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : userData!['image_url'] != null
                              ? NetworkImage(userData!['image_url'])
                              : NetworkImage(
                                  'https://cdn2.iconfinder.com/data/icons/ios-7-icons/50/user_male4-1024.png',
                                ) as ImageProvider,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _usernameController,
                    label: 'Username',
                    maxLength: 20,
                  ),
                  SizedBox(height: 20),
                  _buildGenderPicker(),
                  SizedBox(height: 20),
                  _buildDatePicker(),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _locationController,
                    label: 'Location',
                    maxLength: 30,
                  ),
                  SizedBox(height: 20),
                  _buildBioField(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLength = 30,
  }) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.yellowAccent),
        counterStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.yellowAccent),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.yellowAccent),
        ),
      ),
    );
  }

  Widget _buildGenderPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Gender:',
          style: TextStyle(color: Colors.yellowAccent, fontSize: 16),
        ),
        DropdownButton<String>(
          value: _gender,
          dropdownColor: Colors.grey[900],
          iconEnabledColor: Colors.yellowAccent,
          items: ['Male', 'Female', 'Other']
              .map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(
                      gender,
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _gender = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Birthday:',
          style: TextStyle(color: Colors.yellowAccent, fontSize: 16),
        ),
        InkWell(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: Colors.yellowAccent,
                      onPrimary: Colors.black,
                      surface: Colors.grey[900]!,
                      onSurface: Colors.white,
                    ),
                    dialogBackgroundColor: Colors.black,
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              setState(() {
                _selectedDate = pickedDate;
              });
            }
          },
          child: Row(
            children: [
              Text(
                _selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                    : 'Pick a date',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Icon(
                Icons.calendar_today,
                color: Colors.yellowAccent,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bio',
          style: TextStyle(color: Colors.yellowAccent, fontSize: 16),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _bioController,
          maxLines: 5,
          maxLength: 1000,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Provide a Bio about yourself...',
            hintStyle: TextStyle(color: Colors.grey),
            counterStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellowAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellowAccent),
            ),
          ),
        ),
      ],
    );
  }
}
