import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../home/controllers/coin/market_controller.dart';
import '../../home/entities/coin_data.dart';
import '../controller/wallet/wallet_controller.dart';
import 'wallet_coin_tile.dart';

class WalletCoinsListView extends StatelessWidget {
  const WalletCoinsListView({
    super.key,
    required this.coinIds,
    required this.onTap,
  });

  final List<String> coinIds;
  final void Function(CoinData coin) onTap;

  @override
  Widget build(BuildContext context) {
    final market = context.watch<MarketController>();
    final wallet = context.watch<WalletController>().wallet;

    final coins = coinIds
        .map((id) => market.getCoinFromId(id)) //
        .toList();

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
        final quantity = wallet.coins[coins[i].id]!;
        return WalletCoinTile(
          coin: coins[i],
          quantity: quantity.toDouble(),
          onTap: onTap,
        );
      },
    );
  }
}
