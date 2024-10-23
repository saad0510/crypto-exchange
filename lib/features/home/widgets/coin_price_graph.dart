import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../entities/coin_data.dart';

class CoinPriceGraph extends StatelessWidget {
  const CoinPriceGraph({super.key, required this.coin});

  final CoinData coin;

  @override
  Widget build(BuildContext context) {
    final color = context.primaryColor;
    final today = DateTime.now();

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
        SplineAreaSeries<double, DateTime>(
          animationDuration: 2000,
          splineType: SplineType.monotonic,
          dataSource: coin.lastWeekPrices,
          xValueMapper: (d, i) => today.subtract(Duration(hours: i)),
          yValueMapper: (d, i) => d,
          borderWidth: 2,
          borderColor: context.primaryColor,
          gradient: LinearGradient(
            colors: [
              context.primaryColor.withOpacity(0.3),
              context.primaryColor.withOpacity(0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ],
    );
  }
}
