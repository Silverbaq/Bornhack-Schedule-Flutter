import 'dart:io';

import 'package:bornhack/business_logic/media_archive/media_archive.api.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:pmvvm/view_model.dart';

class UploadMediaViewModel extends ViewModel {
  UploadMediaViewModel(this.mediaApi);

  //final ImagePicker _picker = ImagePicker();
  MediaApi mediaApi;

  String title = '';
  String description = '';
  String source = '';
  String filePath = '';
  String filename = '';
  File? image;

  Future<bool> uploadFile() async {
    try {
      var file = await mediaApi.uploadFile(title, description, source, image?.path ?? '', "testimage");
      if (file != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void updateTitle(String title) {
    this.title = title;
  }

  void updateDescription(String description) {
    this.description = description;
  }

  void updateSource(String source) {
    this.source = source;
  }

  void updateFilePath(String filePath) {
    this.filePath = filePath;
  }

  void updateFilename(String filename) {
    this.filename = filename;
  }

  Future<void> selectedImageFromGallery() async {
    //XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    //if (pickedImage?.path != null) {
   //   image = File(pickedImage?.path ?? "");
   // }

    notifyListeners();
  }
}
