import 'package:flutter/material.dart';

import '../../../app/sizes.dart';
import '../../../app/theme/colors.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/extensions/datetime_ext.dart';
import '../entities/coin_data.dart';

class CoinSummaryBox extends StatelessWidget {
  const CoinSummaryBox({super.key, required this.coin});

  final CoinData coin;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Hero(
          tag: coin.id,
          child: CircleAvatar(
            radius: 34,
            backgroundColor: AppColors.highlight,
            onBackgroundImageError: (_, __) {},
            backgroundImage: NetworkImage(coin.image),
          ),
        ),
        AppSizes.normalX,
        AppSizes.smallX,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              coin.priceStr,
              style: context.textTheme.displayLarge,
            ),
            Row(
              children: [
                Text(
                  coin.priceChangeStr,
                  style: context.textTheme.bodyMedium,
                ),
                AppSizes.smallX,
                Text(
                  coin.priceChangePercentStr,
                  style: context.textTheme.bodyMedium?.copyWith(color: coin.trendColor),
                ),
              ],
            )
          ],
        ),
        const Spacer(),
        Text(
          'Last Updated\n${coin.lastUpdated.datetimeFormated}',
          style: context.textTheme.titleSmall,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
