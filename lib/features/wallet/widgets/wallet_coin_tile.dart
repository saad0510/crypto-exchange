import 'package:flutter/material.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/utils/price_formatting.dart';
import '../../home/entities/coin_data.dart';
import '../../home/widgets/coin_icon.dart';
import '../../home/widgets/price_text.dart';

class WalletCoinTile extends StatelessWidget {
  const WalletCoinTile({
    super.key,
    required this.coin,
    required this.quantity,
    required this.onTap,
  });

  final double quantity;
  final CoinData coin;
  final void Function(CoinData coin) onTap;

  @override
  Widget build(BuildContext context) {
    final total = coin.price * quantity;

    return ListTile(
      onTap: () => onTap(coin),
      horizontalTitleGap: 24,
      contentPadding: AppPaddings.zero,
      leading: Hero(
        tag: coin.id,
        child: CoinIcon(image: coin.image),
      ),
      title: Text(
        coin.name,
        style: context.textTheme.titleLarge?.copyWith(height: 0),
      ),
      subtitle: Text(
        coin.symbol.toUpperCase(),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            formatInPrice(quantity),
            style: context.textTheme.displaySmall?.copyWith(height: 0),
          ),
          PriceText(
            formatInPrice(total),
            size: 16,
          ),
        ],
      ),
    );
  }
}
