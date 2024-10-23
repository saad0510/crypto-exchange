import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';

class SellCoinPeerButton extends StatelessWidget {
  const SellCoinPeerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: const Text('Offer'),
      icon: const Icon(Icons.sell, size: 18),
      onPressed: () => context.push(AppRoutes.addOffer),
      style: TextButton.styleFrom(
        padding: AppPaddings.normalX,
        textStyle: context.textTheme.bodyLarge!.copyWith(height: 0),
      ),
    );
  }
}
