import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/extensions/text_ext.dart';
import '../../home/controllers/coin/market_controller.dart';
import '../../home/entities/coin_data.dart';
import '../../home/widgets/coin_icon.dart';

class CoinDropDownButton extends StatelessWidget {
  const CoinDropDownButton({super.key, required this.onSelected});

  final void Function(CoinData coin) onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<CoinData>(
      elevation: 2,
      iconSize: 28,
      icon: const Icon(Icons.keyboard_arrow_down),
      onSelected: onSelected,
      tooltip: 'Select Coin',
      offset: const Offset(15, 0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      itemBuilder: (_) => context
          .read<MarketController>() //
          .allCoins
          .map<PopupMenuItem<CoinData>>(
            (coin) => PopupMenuItem(
              value: coin,
              key: ValueKey(coin.id),
              padding: AppPaddings.smallXY,
              child: Row(
                children: [
                  CoinIcon(image: coin.image),
                  AppSizes.normalX,
                  Text(
                    coin.name,
                    style: context.textTheme.headlineMedium!.regular,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
