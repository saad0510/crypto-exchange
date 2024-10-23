import 'package:flutter/material.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.actionText,
    required this.onPressed,
  });

  final String title;
  final String actionText;
  final void Function(BuildContext) onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: AppPaddings.normalXY,
      titlePadding: AppPaddings.normalXY,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      backgroundColor: context.backgroundColor,
      title: Text(title, textAlign: TextAlign.center),
      children: [
        ElevatedButton(
          onPressed: () => onPressed(context),
          child: Text(actionText),
        ),
      ],
    );
  }
}
