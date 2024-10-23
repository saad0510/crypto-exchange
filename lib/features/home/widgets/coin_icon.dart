import 'package:flutter/material.dart';

import '../../../app/theme/colors.dart';

class CoinIcon extends StatelessWidget {
  const CoinIcon({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 26,
      backgroundColor: AppColors.highlight,
      onBackgroundImageError: (_, __) {},
      backgroundImage: NetworkImage(image),
    );
  }
}
