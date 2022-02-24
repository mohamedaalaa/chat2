


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {

  final Function(File imageFile) pickedImage;

  const UserImagePicker({Key? key,required this.pickedImage}) : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {

  File? _storedImage;

  Future<void> _takePhoto() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50
    );
    if(imageFile==null){
      return;
    }
    setState(() {
      _storedImage=File(imageFile.path);
    });
    widget.pickedImage(_storedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: _storedImage==null? null : FileImage(_storedImage!) ,
        ),
        TextButton.icon(onPressed:_takePhoto, icon: const Icon(Icons.image), label: const Text('Add Image')),
      ],
    );
  }
}
