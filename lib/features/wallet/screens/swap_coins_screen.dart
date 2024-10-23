import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../../app/theme/colors.dart';
import '../../../core/extensions/context_ext.dart';
import '../../home/entities/coin_data.dart';
import '../controller/wallet/wallet_controller.dart';
import '../widgets/coin_swap_field.dart';

class SwapCoinsScreen extends StatefulWidget {
  const SwapCoinsScreen({super.key});

  @override
  State<SwapCoinsScreen> createState() => _SwapCoinsScreenState();
}

class _SwapCoinsScreenState extends State<SwapCoinsScreen> {
  late final wallet = context.read<WalletController>();

  num available = 0;
  CoinData? src;
  CoinData? target;
  double srcAmount = 0;
  double targetAmount = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Swap Coins'),
        ),
        body: Padding(
          padding: AppPaddings.normalXY,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter the amount of\n${src?.name}s you want to\nswap with ${target?.name}s',
                style: context.textTheme.displayLarge,
              ),
              const Spacer(),
              CoinsSwapField(
                onChange: (src, srcQty, target, targetQty) {
                  final available = wallet.wallet.coins[src.id] ?? 0;
                  this.src = src;
                  this.target = target;
                  srcAmount = srcQty;
                  targetAmount = targetQty;
                  setState(() => this.available = available);
                },
              ),
              const Spacer(flex: 2),
              if (available < srcAmount)
                ElevatedButton(
                  onPressed: null,
                  child: Text(
                    'You only have $available ${src?.name}s',
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
                    await wallet.swapCoins(src!.id, srcAmount, target!.id, targetAmount);
                    pop();
                    pop();
                  },
                  child: const Text('Swap Now'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
