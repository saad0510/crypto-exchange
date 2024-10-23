import 'package:flutter/material.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/extensions/text_ext.dart';
import '../entities/nft_data.dart';

class NFTSummary extends StatelessWidget {
  const NFTSummary({super.key, required this.nft});

  final NFTData nft;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          nft.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.headlineMedium!.regular,
        ),
        AppSizes.smallY,
        Expanded(
          child: SingleChildScrollView(
            child: Text(nft.description, overflow: TextOverflow.fade),
          ),
        ),
      ],
    );
  }
}
