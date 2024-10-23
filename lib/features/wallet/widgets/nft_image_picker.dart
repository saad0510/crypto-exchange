import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker_widget/image_picker_widget.dart';

import '../../../app/theme/colors.dart';
import '../../../app/theme/theme.dart';
import '../../../core/extensions/context_ext.dart';

class NFTImagePicker extends StatefulWidget {
  const NFTImagePicker({super.key, required this.onChange});

  final void Function(File file) onChange;

  @override
  State<NFTImagePicker> createState() => _NFTImagePickerState();
}

class _NFTImagePickerState extends State<NFTImagePicker> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return ImagePickerWidget(
      isEditable: true,
      shouldCrop: false,
      diameter: context.width * 0.5,
      shape: ImagePickerWidgetShape.square,
      backgroundColor: Colors.black26,
      iconAlignment: Alignment.center,
      editIcon: imageFile != null //
          ? const SizedBox()
          : const Icon(
              Icons.add,
              size: 64,
              color: BlackColor.medium,
            ),
      modalOptions: AppTheme.imagePickerModalOptions,
      fit: BoxFit.cover,
      onChange: (x) {
        imageFile = x;
        widget.onChange(x);
        setState(() {});
      },
    );
  }
}
