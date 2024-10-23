import 'package:flutter/material.dart';

import '../../../app/sizes.dart';
import '../entities/coin_data.dart';
import 'coin_tile.dart';

class CoinListView extends StatelessWidget {
  const CoinListView({super.key, required this.coins});

  final List<CoinData> coins;

  @override
  Widget build(BuildContext context) {
    if (coins.isEmpty) {
      return const Center(
        heightFactor: 10,
        child: Text('No coins to show'),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: coins.length,
      separatorBuilder: (context, i) => AppSizes.smallY,
      itemBuilder: (context, i) {
        return CoinTile(coin: coins[i]);
      },
    );
  }
}
