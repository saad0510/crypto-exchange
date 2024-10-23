import 'package:flutter/material.dart';

import '../../../core/extensions/context_ext.dart';

class TextActionButton extends StatelessWidget {
  const TextActionButton({
    super.key,
    this.leading = "",
    required this.highlight,
    this.underline = true,
    required this.onPressed,
  });

  final String leading;
  final String highlight;
  final bool underline;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: leading,
              style: context.textTheme.bodyMedium,
            ),
            TextSpan(
              text: highlight,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                decoration: underline ? TextDecoration.underline : null,
                color: context.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
