import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImageButton extends StatelessWidget {
  const PickImageButton({super.key, required this.onPicked});

  final void Function(List<File>) onPicked;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final xfiles = await ImagePicker().pickMultiImage();
        final files = xfiles.map(
          (xfile) => File(xfile.path),
        );
        onPicked(files.toList());
      },
      icon: const Icon(Icons.add),
      label: const Text('Add Images'),
    );
  }
}
