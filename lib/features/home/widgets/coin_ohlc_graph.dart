import 'package:coingecko_api/data/ohlc_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../controllers/coin/market_controller.dart';
import '../entities/coin_data.dart';

class CoinOHLCGraph extends StatelessWidget {
  const CoinOHLCGraph({super.key, required this.coin});

  final CoinData coin;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.watch<MarketController>().marketChart(coin.id),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(
            heightFactor: 10,
            child: Text('Loading'),
          );
        }
        if (snap.hasError) {
          return Center(
            child: Text(snap.error.toString()),
          );
        }

        final color = context.primaryColor;
        final points = snap.data!;

        return SfCartesianChart(
          margin: AppPaddings.zero,
          plotAreaBorderWidth: 0,
          primaryYAxis: NumericAxis(isVisible: false),
          primaryXAxis: DateTimeAxis(isVisible: false),
          trackballBehavior: TrackballBehavior(
            enable: true,
            lineColor: color,
            activationMode: ActivationMode.singleTap,
            tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
            tooltipSettings: InteractiveTooltip(
              enable: true,
              color: context.backgroundColor,
              textStyle: context.textTheme.titleSmall!.copyWith(color: context.contrastColor),
            ),
            markerSettings: TrackballMarkerSettings(
              borderColor: color,
              borderWidth: 6,
              width: 6,
              height: 6,
              markerVisibility: TrackballVisibilityMode.visible,
              shape: DataMarkerType.circle,
            ),
          ),
          series: <ChartSeries>[
            CandleSeries<OHLCInfo, DateTime>(
              borderWidth: 2,
              animationDuration: 1000,
              dataSource: points,
              xValueMapper: (d, i) => d.timestamp,
              highValueMapper: (d, i) => d.high,
              lowValueMapper: (d, i) => d.low,
              openValueMapper: (d, i) => d.open,
              closeValueMapper: (d, i) => d.close,
            ),
          ],
        );
      },
    );
  }
}
