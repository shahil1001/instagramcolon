
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


  PickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
     XFile? imagefile = await _picker.pickImage(source: source);
    if (imagefile != null) {
      return await imagefile
          .readAsBytes(); // this will return the name of the file
    }else{
      print("No Images is selected");
    }
  }

ShowMessage(BuildContext context,String text){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}