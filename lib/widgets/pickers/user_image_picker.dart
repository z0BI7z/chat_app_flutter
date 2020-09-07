import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Future<void> Function({File imageFile}) onSelect;

  UserImagePicker({
    @required this.onSelect,
  });

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final _picker = ImagePicker();
  File _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 300,
    );
    setState(() {
      _imageFile = File(pickedFile.path);
    });
    widget.onSelect(imageFile: _imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Theme.of(context).primaryColor,
          backgroundImage: _imageFile != null ? FileImage(_imageFile) : null,
        ),
        FlatButton.icon(
          icon: Icon(Icons.image),
          label: Text('Add Image'),
          onPressed: _pickImage,
          textColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
