import 'package:appear_ai_image_editor/presentation/widgets/snack_bar_message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:flutter/material.dart';

Future<File?> pickAndCropImage(BuildContext context, ImageSource source) async {
  final ImagePicker _picker = ImagePicker();
  try {
    // Step 1: Pick an image from the specified source
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile == null) {
      return null;
    }

    // Step 2: Crop the image
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Color(0xFF2f0743),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          minimumAspectRatio: 1.0,
        ),
      ],
    );

    // Return the cropped image file if available
    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      showSnackBarMessage(
        title: 'Error',
        message: 'Image cropping canceled',
      );
      return null;
    }
  } catch (e) {
    print('Error picking or cropping image: $e');
    showSnackBarMessage(
      title: 'Error',
      message: 'Failed to pick or crop image',
    );
    return null;
  }
}
