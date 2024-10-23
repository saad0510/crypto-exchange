import 'package:flutter/material.dart';

import '../../../app/sizes.dart';
import '../entities/coin_data.dart';
import '../widgets/coin_graphs.dart';
import '../widgets/coin_info_box.dart';
import '../widgets/coin_summary_box.dart';
import '../widgets/coin_trade_buttons.dart';

class CoinDetailScreen extends StatelessWidget {
  const CoinDetailScreen({super.key, required this.coin});

  final CoinData coin;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('${coin.name}  /  USD'),
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Padding(
                    padding: AppPaddings.normalXY,
                    child: CoinSummaryBox(coin: coin),
                  ),
                  const Spacer(),
                  CoinGraphs(coin: coin),
                  const Spacer(),
                  Padding(
                    padding: AppPaddings.normalXY,
                    child: CoinInfoBox(coin: coin),
                  ),
                  AppSizes.normalY,
                  Padding(
                    padding: AppPaddings.normalXY,
                    child: CoinTradeButtons(coin: coin),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
