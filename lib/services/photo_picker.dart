import 'dart:io';

import 'package:image_picker/image_picker.dart';

class PhotoPicker {
  File _image;
  ImagePicker picker = ImagePicker();
  Future pickImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    _image = File(pickedFile.path);
    return _image;
  }
}
