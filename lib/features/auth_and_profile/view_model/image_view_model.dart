import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageViewModel extends ChangeNotifier {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  File? get pickedImage => _pickedImage;

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _pickedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  void clearImage() {
    _pickedImage = null;
    notifyListeners();
  }
}
