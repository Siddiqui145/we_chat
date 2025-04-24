import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePickerWidget extends StatefulWidget {
  const UserImagePickerWidget({super.key});

  @override
  State<UserImagePickerWidget> createState() => _UserImagePickerWidgetState();
}

class _UserImagePickerWidgetState extends State<UserImagePickerWidget> {

  File? _pickedImageFile;

  void pickImage() async{
    //Size & quality reduced, can use camera or gallery as source
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery, 
      imageQuality: 50, 
      maxWidth: 150);

      if(pickedImage == null){ // check is necessary as ahead we display
        return;
      }

      setState(() {
        _pickedImageFile = File(pickedImage.path);  // using File package to convert our image into a type file
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey,
          foregroundImage: _pickedImageFile != null ? FileImage(_pickedImageFile!) : null, //FileImage is a type diff & necessary
        ),
        TextButton.icon(
          onPressed: pickImage,
          icon: Icon(Icons.image),
          label: Text("Add Image",
          style: TextStyle(color: Theme.of(context).colorScheme.primary,)),)
      ],
    );
  }
}