import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/routes.dart';
import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../auth/controllers/auth/auth_controller.dart';
import '../../home/controllers/coin/market_controller.dart';
import '../../home/entities/coin_data.dart';
import '../../home/widgets/section_header.dart';
import '../../home/widgets/nft_list_view.dart';
import '../controller/wallet/wallet_controller.dart';
import '../widgets/add_nft_button.dart';
import '../widgets/wallet_balance_box.dart';
import '../widgets/wallet_coins_list_view.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthController>().user.uid;
    final myNfts = context.watch<MarketController>().nftsOf(uid);
    final wallet = context.watch<WalletController>();
    final coinIds = wallet.wallet.coins.keys.toList();
    coinIds.remove(CoinData.usdCoin.id);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Wallet'),
          actions: const [AddNFTButton()],
        ),
        body: SingleChildScrollView(
          padding: AppPaddings.normalXY,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const WalletBalanceBox(),
              AppSizes.maxY,
              Text(
                'Assets',
                style: context.textTheme.displaySmall,
              ),
              AppSizes.largeY,
              SectionHeader(
                filters: const ['Coins', 'NFTS'],
                selected: selected,
                onSelected: (i) => setState(() => selected = i),
              ),
              AppSizes.largeY,
              selected == 0 //
                  ? WalletCoinsListView(
                      coinIds: coinIds,
                      onTap: (coin) => context.push(AppRoutes.coinDetail, arguments: coin),
                    )
                  : NFTListView(nfts: myNfts)
            ],
          ),
        ),
      ),
    );
  }
}
