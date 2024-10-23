import 'package:flutter/material.dart';

import '../../../app/theme/colors.dart';
import '../../../core/extensions/context_ext.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final color = context.isDarkMode ? AppColors.white : AppColors.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(color: color, height: 100, endIndent: 15),
        ),
        Text(
          text,
          style: TextStyle(color: color, height: 1),
        ),
        Expanded(
          child: Divider(color: color, height: 100, indent: 15),
        ),
      ],
    );
  }
}
