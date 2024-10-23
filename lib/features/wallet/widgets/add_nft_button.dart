import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';

class AddNFTButton extends StatelessWidget {
  const AddNFTButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: const Text('NFT'),
      icon: const Icon(Icons.add, size: 20),
      onPressed: () => context.push(AppRoutes.addNFT),
      style: TextButton.styleFrom(
        padding: AppPaddings.normalX,
        textStyle: context.textTheme.bodyLarge!.copyWith(height: 0),
      ),
    );
  }
}
