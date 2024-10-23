import 'package:flutter/material.dart';

import '../../../app/sizes.dart';
import '../../../core/utils/price_formatting.dart';
import '../../home/entities/coin_data.dart';
import 'coin_quantity_field.dart';

class CoinsExchangeField extends StatefulWidget {
  const CoinsExchangeField({
    super.key,
    required this.coin1,
    required this.coin2,
    required this.onChange,
  });

  final CoinData coin1;
  final CoinData coin2;
  final void Function(double coin1, double coin2) onChange;

  @override
  State<CoinsExchangeField> createState() => _CoinsExchangeFieldState();
}

class _CoinsExchangeFieldState extends State<CoinsExchangeField> {
  late final coin1Controller = TextEditingController(text: '1');
  late final coin2Controller = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CoinQuantityField(
          coin: widget.coin1,
          onChanged: setCoin2,
          textController: coin1Controller,
        ),
        AppSizes.largeY,
        CoinQuantityField(
          coin: widget.coin2,
          onChanged: setCoin1,
          textController: coin2Controller,
        ),
      ],
    );
  }

  void setCoin1(String _) {
    final txt = coin2Controller.text.trim();
    if (txt.isEmpty) return;

    final coins2 = double.parse(txt);
    final coins1 = (coins2 * widget.coin2.price) / widget.coin1.price;
    coin1Controller.text = formatInPrice(coins1).replaceAll(',', '');
    widget.onChange(coins1, coins2);
  }

  void setCoin2(String _) {
    final txt = coin1Controller.text.trim();
    if (txt.isEmpty) return;

    final coins1 = double.parse(txt);
    final coins2 = (coins1 * widget.coin1.price) / widget.coin2.price;
    coin2Controller.text = formatInPrice(coins2).replaceAll(',', '');
    widget.onChange(coins1, coins2);
  }

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () => setCoin2(''),
    );
    super.initState();
  }

  @override
  void dispose() {
    coin1Controller.dispose();
    coin2Controller.dispose();
    super.dispose();
  }
}
