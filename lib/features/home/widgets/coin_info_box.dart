import 'package:flutter/material.dart';

import '../../../app/sizes.dart';
import '../entities/coin_data.dart';
import 'property_box.dart';

class CoinInfoBox extends StatelessWidget {
  const CoinInfoBox({super.key, required this.coin});

  final CoinData coin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PropertyBox(
              label: 'Curr Supply',
              value: coin.supplyStr,
            ),
            PropertyBox(
              label: 'Market Cap',
              value: coin.marketCapStr,
            ),
            PropertyBox(
              label: 'Lowest',
              value: coin.lowestStr,
            ),
          ],
        ),
        AppSizes.normalY,
        AppSizes.smallY,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PropertyBox(
              label: 'Max Supply',
              value: coin.maxSupplyStr,
            ),
            PropertyBox(
              label: 'Volume',
              value: coin.volumeStr,
            ),
            PropertyBox(
              label: 'Highest',
              value: coin.highestStr,
            ),
          ],
        ),
      ],
    );
  }
}
