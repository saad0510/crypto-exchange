import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/assets.dart';
import '../../../app/routes.dart';
import '../../../app/sizes.dart';
import '../../../app/theme/colors.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/utils/app_coins.dart';
import '../../../core/utils/price_formatting.dart';
import '../../home/controllers/coin/market_controller.dart';
import '../../home/widgets/price_text.dart';
import '../controller/wallet/metamask_controller.dart';
import '../controller/wallet/wallet_controller.dart';

class WalletDepositScreen extends StatelessWidget {
  const WalletDepositScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final metamask = context.watch<MetaMaskController>();
    final market = context.watch<MarketController>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Deposit Screen')),
        body: Padding(
          padding: AppPaddings.normalXY,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSizes.maxY,
              Text(
                'Connect with our\nproviders and deposit\nbalance',
                style: context.textTheme.displayLarge,
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  border: Border.all(color: BlackColor.normal, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: TextButton.icon(
                  onPressed: () => context.push(AppRoutes.bankDeposit),
                  icon: Icon(
                    Icons.account_balance,
                    size: 24,
                    color: context.contrastColor,
                  ),
                  label: const Text(' Connect with Bank'),
                ),
              ),
              AppSizes.normalY,
              Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  border: Border.all(color: BlackColor.normal, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: TextButton.icon(
                  onPressed: () async {
                    await metamask.connect();
                    final bnbs = await metamask.balance;
                    final usds = bnbs * market.getCoin(AppCoins.binanceCoin).price;
                    // ignore: use_build_context_synchronously
                    confirmDialog(context, usds, metamask.address);
                  },
                  icon: Image.asset(AppAssets.metaMask, height: 28),
                  label: metamask.isConnected //
                      ? const Text(' Connected with MetaMask')
                      : const Text(" Connect with MetaMask"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void confirmDialog(BuildContext context, double balance, String address) async {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: context.backgroundColor,
          contentPadding: AppPaddings.normalXY,
          titlePadding: AppPaddings.normalXY,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          title: Column(
            children: [
              const Text(
                'MetaMask wants to connect',
              ),
              PriceText(formatInPrice(balance)),
            ],
          ),
          children: [
            ElevatedButton(
              onPressed: () async {
                context.showLoadingIndicator();
                final pop = context.pop;
                final wallet = context.read<WalletController>();
                await wallet.connectMetaMask(balance, address);
                pop();
                pop();
              },
              child: const Text('Confirm Transaction'),
            )
          ],
        );
      },
    );
  }
}
