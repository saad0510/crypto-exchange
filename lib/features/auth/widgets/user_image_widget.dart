import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker_widget/image_picker_widget.dart';

import '../../../app/theme/colors.dart';
import '../../../app/theme/theme.dart';

class UserImageWidget extends StatelessWidget {
  const UserImageWidget({
    super.key,
    required this.imageUrl,
    this.isEditable = false,
    this.radius = 50,
    this.onChanged,
  });

  final String imageUrl;
  final bool isEditable;
  final double radius;
  final void Function(File)? onChanged;

  @override
  Widget build(BuildContext context) {
    if (isEditable) {
      return ImagePickerWidget(
        diameter: radius * 2,
        initialImage: imageUrl,
        shape: ImagePickerWidgetShape.circle,
        isEditable: true,
        shouldCrop: false,
        iconAlignment: Alignment.bottomRight,
        editIcon: const CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.highlight,
          child: Icon(Icons.camera_alt, size: 16, color: BlackColor.dark),
        ),
        modalOptions: AppTheme.imagePickerModalOptions,
        fit: BoxFit.cover,
        onChange: onChanged,
      );
    }

    return CircleAvatar(
      radius: radius,
      foregroundImage: NetworkImage(imageUrl),
      backgroundColor: Colors.grey,
      onForegroundImageError: (_, __) {},
      child: Icon(Icons.person, size: radius * 1.3, color: Colors.black87),
    );
  }
}
