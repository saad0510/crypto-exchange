import 'package:flutter/material.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../entities/coin_data.dart';
import 'coin_ohlc_graph.dart';
import 'coin_price_graph.dart';

class CoinGraphs extends StatefulWidget {
  const CoinGraphs({super.key, required this.coin});

  final CoinData coin;

  @override
  State<CoinGraphs> createState() => _CoinGraphsState();
}

class _CoinGraphsState extends State<CoinGraphs> {
  int selected = 1;
  static const filters = ['OHLC', 'Price'];
  late final graphs = [
    CoinOHLCGraph(coin: widget.coin),
    CoinPriceGraph(coin: widget.coin),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 320,
          child: graphs[selected],
        ),
        AppSizes.normalY,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: List.generate(
            filters.length,
            (i) => GestureDetector(
              onTap: () => setState(() => selected = i),
              child: Padding(
                padding: AppPaddings.normalX.copyWith(left: 0),
                child: Text(
                  filters[i],
                  style: TextStyle(
                    height: 0,
                    color: selected == i ? context.primaryColor : null,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
