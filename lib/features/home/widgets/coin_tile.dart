import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../entities/coin_data.dart';
import 'coin_icon.dart';
import 'price_text.dart';

class CoinTile extends StatelessWidget {
  const CoinTile({super.key, required this.coin});

  final CoinData coin;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.push(AppRoutes.coinDetail, arguments: coin),
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
          PriceText(coin.priceStr, size: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                coin.priceChangeStr,
                style: context.textTheme.titleMedium,
              ),
              AppSizes.smallX,
              Text(
                coin.priceChangePercentStr,
                style: context.textTheme.titleMedium?.copyWith(color: coin.trendColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
