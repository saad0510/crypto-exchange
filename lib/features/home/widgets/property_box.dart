import 'package:flutter/material.dart';

import '../../../core/extensions/context_ext.dart';
import '../../../core/extensions/text_ext.dart';

class PropertyBox extends StatelessWidget {
  const PropertyBox({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: context.textTheme.bodyMedium!.light,
        ),
        Text(
          value,
          style: context.textTheme.displaySmall!.regular,
        ),
      ],
    );
  }
}
