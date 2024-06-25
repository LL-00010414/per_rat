import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({
    super.key,
    required this.onPickImage,
  });

  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile1;
  File? _pickedImageFile2;

  @override
  void initState() {
    super.initState();
  }

  void _pickImageCamera() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile1 = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile1!);
  }

  void _pickImageGallery() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile2 = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile2!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          child: Icon(
            Icons.account_box,
            size: 120,
          ),
          // Text(
          //   'Choose Image',
          //   style: TextStyle(color: Colors.amber),
          // ),
          radius: 100,
          backgroundColor: Colors.transparent,
          foregroundImage: _pickedImageFile1 != null
              ? FileImage(_pickedImageFile1!)
              : (_pickedImageFile2 != null
                  ? FileImage(_pickedImageFile2!)
                  : null),
        ),
        Container(
          width: 120,
          decoration: BoxDecoration(
            border: Border.all(
              width: 5,
              color: Colors.white54,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _pickImageCamera,
                icon: const Icon(Icons.camera_alt, color: Colors.grey),
                // label: Text(
                //   'Add Image',
                //   style: TextStyle(color: Theme.of(context).colorScheme.primary),
                // ),
              ),
              IconButton(
                onPressed: _pickImageGallery,
                icon: const Icon(
                  Icons.image_outlined,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
