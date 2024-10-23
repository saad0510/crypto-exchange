import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../../app/theme/colors.dart';
import '../../../core/extensions/context_ext.dart';
import '../../home/entities/coin_data.dart';
import '../controller/wallet/wallet_controller.dart';
import '../widgets/coins_exchange_field.dart';

class SellCoinScreen extends StatefulWidget {
  const SellCoinScreen({super.key, required this.sellingCoin});

  final CoinData sellingCoin;

  @override
  State<SellCoinScreen> createState() => _BuyCoinScreenState();
}

class _BuyCoinScreenState extends State<SellCoinScreen> {
  late final wallet = context.read<WalletController>();

  num available = 0;
  double srcAmount = 0;
  double targetAmount = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sell ${widget.sellingCoin.name}'),
        ),
        body: Padding(
          padding: AppPaddings.normalXY,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'Enter the amount of\n${widget.sellingCoin.name}s you want to\nsell for USDs',
                style: context.textTheme.displayLarge,
              ),
              const Spacer(flex: 2),
              CoinsExchangeField(
                coin1: widget.sellingCoin,
                coin2: CoinData.usdCoin,
                onChange: (coin1, coin2) {
                  final available = wallet.wallet.coins[widget.sellingCoin.id] ?? 0;
                  srcAmount = coin1;
                  targetAmount = coin2;
                  setState(() => this.available = available);
                },
              ),
              const Spacer(flex: 3),
              if (available < srcAmount)
                ElevatedButton(
                  onPressed: null,
                  child: Text(
                    'You only have $available ${widget.sellingCoin.name}s',
                    style: TextStyle(
                      fontSize: 17,
                      color: AppColors.colors.error,
                    ),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () async {
                    final pop = context.pop;
                    context.showLoadingIndicator();
                    await wallet.swapCoins(
                      widget.sellingCoin.id,
                      srcAmount,
                      CoinData.usdCoin.id,
                      targetAmount,
                    );
                    pop();
                  },
                  child: const Text('Sell'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
