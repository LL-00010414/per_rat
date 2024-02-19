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
          radius: 60,
          backgroundColor: Colors.grey,
          foregroundImage: _pickedImageFile1 != null
              ? FileImage(_pickedImageFile1!)
              : (_pickedImageFile2 != null
                  ? FileImage(_pickedImageFile2!)
                  : null),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _pickImageCamera,
              icon: const Icon(Icons.camera_alt),
              // label: Text(
              //   'Add Image',
              //   style: TextStyle(color: Theme.of(context).colorScheme.primary),
              // ),
            ),
            IconButton(
              onPressed: _pickImageGallery,
              icon: const Icon(Icons.image_outlined),
            ),
          ],
        ),
      ],
    );
  }
}
