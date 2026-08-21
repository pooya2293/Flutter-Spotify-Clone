import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(content)));
}

Future<File?> pickImage() async {
  try {
    final files = await FilePicker.pickFiles(type: FileType.image);

    if (files.isNotEmpty) {
      return File(files.first.path!);
    }

    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> pickAudio() async {
  try {
    final files = await FilePicker.pickFiles(type: FileType.audio);

    if (files.isNotEmpty) {
      return File(files.first.path!);
    }

    return null;
  } catch (e) {
    return null;
  }
}
