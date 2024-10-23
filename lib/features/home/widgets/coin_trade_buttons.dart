import 'package:flutter/material.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../wallet/screens/buy_coin_screen.dart';
import '../../wallet/screens/select_coin_screen.dart';
import '../../wallet/screens/sell_coin_screen.dart';
import '../entities/coin_data.dart';

class CoinTradeButtons extends StatelessWidget {
  const CoinTradeButtons({super.key, required this.coin});

  final CoinData coin;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.backgroundColor,
              foregroundColor: context.contrastColor,
            ),
            onPressed: () {
              context.to(
                SelectCoinScreen(
                  excludeIds: [coin.id],
                  onSelected: (sellCoin) {
                    context.to(
                      BuyCoinScreen(sellingCoin: sellCoin, targetCoin: coin),
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.arrow_downward),
            label: const Text('Buy'),
          ),
        ),
        AppSizes.normalX,
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.backgroundColor,
              foregroundColor: context.contrastColor,
            ),
            onPressed: () => context.to(
              SellCoinScreen(sellingCoin: coin),
            ),
            icon: const Icon(Icons.arrow_upward),
            label: const Text('Sell'),
          ),
        ),
      ],
    );
  }
}
