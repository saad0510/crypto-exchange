import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/constants.dart';
import '../../../app/routes.dart';
import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/extensions/text_ext.dart';
import '../../../core/utils/app_coins.dart';
import '../../../core/utils/price_formatting.dart';
import '../../home/controllers/coin/market_controller.dart';
import '../../home/widgets/price_text.dart';
import '../controller/wallet/wallet_controller.dart';
import 'wallet_button.dart';

class WalletBalanceBox extends StatelessWidget {
  const WalletBalanceBox({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletController>();
    final market = context.watch<MarketController>();
    final bitCoin = market.getCoin(AppCoins.bitcoin);
    final btcBalance = wallet.balance / bitCoin.price;

    return Column(
      children: [
        AppSizes.normalY,
        Hero(
          tag: AppConstants.walletBalanceTag,
          child: PriceText(
            formatInPrice(wallet.balance),
            size: 46,
          ),
        ),
        AppSizes.smallY,
        Text(
          '${formatInPrice(btcBalance)} BTC',
          style: context.textTheme.titleLarge!.light,
        ),
        AppSizes.maxY,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // WalletButton(
            //   label: 'Trade',
            //   icon: Icons.swap_horiz,
            //   onPressed: () {},
            // ),
            WalletButton(
              label: 'Withdraw',
              icon: Icons.arrow_downward,
              onPressed: () => context.push(AppRoutes.bankWithdraw),
            ),
            AppSizes.normalX,
            WalletButton(
              label: 'Deposit',
              icon: Icons.arrow_upward,
              onPressed: () => context.push(AppRoutes.deposit),
            ),
          ],
        ),
        AppSizes.normalY,
      ],
    );
  }
}
