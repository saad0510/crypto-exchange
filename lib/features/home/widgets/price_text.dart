import 'package:flutter/material.dart';

import '../../../core/extensions/context_ext.dart';

class PriceText extends StatelessWidget {
  const PriceText(
    this.price, {
    super.key,
    this.color,
    this.size,
  });

  final String price;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '\$ ',
        style: TextStyle(
          color: color ?? context.contrastColor,
          fontSize: size == null ? 18 : size! * 0.7,
        ),
        children: [
          TextSpan(
            text: price,
            style: TextStyle(
              fontSize: size ?? 28,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
