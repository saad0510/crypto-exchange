import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/extensions/text_ext.dart';
import '../../../core/utils/app_coins.dart';
import '../../../core/utils/price_formatting.dart';
import '../../home/controllers/coin/market_controller.dart';
import '../../home/entities/coin_data.dart';
import 'coin_quantity_field.dart';

class CoinsSwapField extends StatefulWidget {
  const CoinsSwapField({super.key, required this.onChange});

  final void Function(
    CoinData source,
    double sourceQuantity,
    CoinData target,
    double targetQuantity,
  ) onChange;

  @override
  State<CoinsSwapField> createState() => _CoinsSwapFieldState();
}

class _CoinsSwapFieldState extends State<CoinsSwapField> {
  late final sourceController = TextEditingController(text: '1');
  late final targetController = TextEditingController(text: '1');
  late final market = context.watch<MarketController>();

  late CoinData sourceCoin = market.getCoin(AppCoins.bitcoin);
  late CoinData targetCoin = CoinData.usdCoin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Your Coin',
          style: context.textTheme.titleLarge!.regular,
        ),
        AppSizes.largeY,
        CoinQuantityField(
          coin: sourceCoin,
          onChanged: setTarget,
          textController: sourceController,
          onCoinChange: (coin) {
            setState(() => sourceCoin = coin);
            setSource('');
          },
        ),
        AppSizes.maxY,
        AppSizes.normalY,
        Text(
          'Target Coin',
          style: context.textTheme.titleLarge!.regular,
        ),
        AppSizes.largeY,
        CoinQuantityField(
          coin: targetCoin,
          onChanged: setSource,
          textController: targetController,
          onCoinChange: (coin) {
            setState(() => targetCoin = coin);
            setTarget('');
          },
        ),
      ],
    );
  }

  void setSource(String _) {
    final txt = targetController.text.trim();
    if (txt.isEmpty) return;

    final coins2 = double.parse(txt);
    final coins1 = (coins2 * targetCoin.price) / sourceCoin.price;
    sourceController.text = formatInPrice(coins1).replaceAll(',', '');

    widget.onChange(sourceCoin, coins1, targetCoin, coins2);
  }

  void setTarget(String _) {
    final txt = sourceController.text.trim();
    if (txt.isEmpty) return;

    final coins1 = double.parse(txt);
    final coins2 = (coins1 * sourceCoin.price) / targetCoin.price;
    targetController.text = formatInPrice(coins2).replaceAll(',', '');

    widget.onChange(sourceCoin, coins1, targetCoin, coins2);
  }

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () => setTarget(''),
    );
    super.initState();
  }

  @override
  void dispose() {
    sourceController.dispose();
    targetController.dispose();
    super.dispose();
  }
}
