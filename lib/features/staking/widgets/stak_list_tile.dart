import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/extensions/datetime_ext.dart';
import '../../../core/utils/price_formatting.dart';
import '../../home/controllers/coin/market_controller.dart';
import '../../home/widgets/coin_icon.dart';
import '../../home/widgets/price_text.dart';
import '../../wallet/controller/wallet/wallet_controller.dart';
import '../entities/stak_data.dart';

class StakListTile extends StatelessWidget {
  const StakListTile({super.key, required this.stak});

  final StakData stak;

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletController>();
    final isClaim = wallet.checkStak(stak);
    final coin = context.watch<MarketController>().getCoinFromId(stak.coinId);
    final total = coin.price * stak.amount;
    final months = stak.expiryDate.difference(DateTime.now()).inDays / 30;

    return ListTile(
      onTap: () {},
      horizontalTitleGap: 24,
      contentPadding: AppPaddings.zero,
      leading: CoinIcon(image: coin.image),
      title: Text(
        coin.name,
        style: context.textTheme.titleLarge?.copyWith(height: 0),
      ),
      subtitle: Text(
        'Expires at ${stak.expiryDate.ageStr}',
      ),
      trailing: isClaim
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(padding: AppPaddings.smallXY),
              onPressed: () async {
                final pop = context.pop;
                final showSnackBar = context.showSnackBar;
                context.showLoadingIndicator();
                await wallet.reduceStak(stak);
                showSnackBar(message: "Claimed ${stak.profit}");
                pop();
              },
              child: Text("Claim ${stak.profit}"),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PriceText(formatInPrice(total), size: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '+${stak.rate * 100}%',
                      style: context.textTheme.titleMedium?.copyWith(color: Colors.green),
                    ),
                    AppSizes.smallX,
                    Text(
                      'in ${months.toStringAsFixed(1)} months',
                      style: context.textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
