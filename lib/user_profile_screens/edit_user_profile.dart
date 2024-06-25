import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:per_rat/data/user_gender.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/models/user_gender.dart';

import 'user_image_picker.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final _formkey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;

  File? _selectedImage;
  var _isUploading = false;
  var _enteredUsername = '';
  Gender? _enteredGender;
  //genders[Genders.male];
  DateTime? _enteredBD;
  //DateTime.now().subtract(const Duration(days: 3650));
  String? _enteredLocation;
  List<String>? _enteredBio;

  void _datePicker() async {
    //final now = DateTime.now();
    final firstDate = DateTime(1950, 1, 1);
    final lastDate = DateTime.now().subtract(const Duration(days: 3650));
    final pickedDate = await showDatePicker(
        context: context,
        firstDate: firstDate,
        lastDate: lastDate,
        initialDate: lastDate);
    setState(() {
      _enteredBD = pickedDate!;
    });
  }

  void _submit() async {
    final isValid = _formkey.currentState!.validate();

    if (!isValid || _selectedImage == null) {
      return;
    }

    _formkey.currentState!.save();

    try {
      setState(() {
        _isUploading = true;
      });
      //final userCredential = FirebaseAuth.instance.currentUser;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${user.uid}.jpg');

      await storageRef.putFile(_selectedImage!);
      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': _enteredUsername,
        'email': user.email,
        'image_url': imageUrl,
        'gender': _enteredGender!.title,
        'birthday': _enteredBD,
        'location': _enteredLocation ?? '',
        'last_online': Timestamp.now(),
        'bio': _enteredBio ?? '',
      });

      Navigator.of(context).pop();
      // else
    } on FirebaseAuthException catch (error) {
      if (error.code.isNotEmpty) {
        //
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message!),
        ),
      );
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.save,
              size: 35,
            ))
      ]),
      //backgroundColor: Theme.of(context).colorScheme.onSecondary,
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        UserImagePicker(
                          onPickImage: (pickedImage) {
                            _selectedImage = pickedImage;
                          },
                        ),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          maxLength: 20,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.amber),
                          ),
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length < 4) {
                              return 'Username should contain at least 4 characters!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredUsername = value!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              //alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Gender:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: Colors.amber),
                              ),
                            ),
                            Container(
                              //alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.only(right: 60),
                              child: Text(
                                'Birthday:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: Colors.amber),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 135,
                              child: DropdownButtonFormField(
                                menuMaxHeight: 250,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                //style: TextStyle(color: Colors.amber),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                dropdownColor: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant,
                                padding: const EdgeInsets.only(
                                  top: 15,
                                  bottom: 15,
                                ),
                                value: _enteredGender,
                                items: [
                                  for (final gender in genders.entries)
                                    DropdownMenuItem(
                                      enabled: true,
                                      value: gender.value,
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 6),
                                          Text(gender.value.title),
                                        ],
                                      ),
                                    ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _enteredGender = value!;
                                  });
                                },
                                onSaved: (value) {
                                  _enteredGender = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 135,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    //formatter.format(_enteredBD!) ?? 'Pick a Date',

                                    _enteredBD == null
                                        ? 'Pick a date'
                                        : formatter.format(_enteredBD!),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  IconButton(
                                    onPressed: _datePicker,
                                    icon: const Icon(
                                      Icons.calendar_month_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          maxLength: 30,
                          decoration: InputDecoration(
                            labelText: 'Location',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.amber),
                          ),
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length < 4) {
                              return 'Location should contain at least 4 characters!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredLocation = value!;
                          },
                        ),
                        const SizedBox(height: 22),
                        TextFormField(
                          textAlign: TextAlign.start,
                          textInputAction: TextInputAction.next,
                          maxLengthEnforcement:
                              MaxLengthEnforcement.truncateAfterCompositionEnds,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          maxLength: 1000,
                          maxLines: null,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            errorMaxLines: 2,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            helperMaxLines: 4,
                            hintText: 'Provide a Bio about yourself...',
                            hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                            hintMaxLines: 4,
                            contentPadding: EdgeInsets.all(20),
                            border: OutlineInputBorder(),
                            label: Text(
                              'Bio',
                            ),
                            labelStyle: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.amber),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length <= 10 ||
                                value.trim().length > 1000) {
                              return 'Must be between 10 and 1000 characters.';
                            }
                            return null;
                          },
                          onSaved: ([value]) {
                            _enteredBio = [value!];
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (_isUploading) const CircularProgressIndicator(),
                        if (!_isUploading)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                // Color.fromARGB(255, 69, 116, 39),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: _submit,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  // Theme.of(context)
                                  //     .colorScheme
                                  //     .onSurface,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
