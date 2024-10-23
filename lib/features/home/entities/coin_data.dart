import 'dart:math';

import 'package:coingecko_api/data/coin.dart';
import 'package:coingecko_api/data/market_data.dart';
import 'package:flutter/material.dart';

import '../../../app/constants.dart';
import '../../../core/utils/price_formatting.dart';

class CoinData {
  final String id;
  final String name;
  final String symbol;
  final String image;
  final double price;
  final double highest;
  final double lowest;
  final double volume;
  final double marketCap;
  final double currSupply;
  final double maxSupply;
  final double priceChange;
  final double priceChangePercent;
  final DateTime lastUpdated;
  final List<double> lastWeekPrices;
  final Map<String, MarketData> markets;

  const CoinData({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.price,
    required this.highest,
    required this.lowest,
    required this.volume,
    required this.marketCap,
    required this.currSupply,
    required this.maxSupply,
    required this.priceChange,
    required this.priceChangePercent,
    required this.lastUpdated,
    required this.markets,
    required this.lastWeekPrices,
  });

  factory CoinData.fromGeckCoin(Coin coin) {
    final marketData = coin.marketData?.dataByCurrency ?? [];
    final entries = marketData.map((market) => MapEntry(market.coinId, market));
    final markets = Map<String, MarketData>.fromEntries(entries);
    final usdMarket = markets['usd']!;
    final lastWeekPrices = coin.marketData!.sparkline7d!.price;

    return CoinData(
      id: coin.id,
      name: coin.name,
      symbol: coin.symbol,
      image: coin.image!.large ?? '',
      price: usdMarket.currentPrice ?? 0,
      highest: lastWeekPrices.reduce(max),
      lowest: lastWeekPrices.reduce(min),
      volume: usdMarket.totalVolume ?? 0,
      marketCap: usdMarket.marketCap ?? 0,
      currSupply: coin.marketData!.circulatingSupply ?? 0,
      maxSupply: coin.marketData!.maxSupply ?? 0,
      priceChange: usdMarket.priceChangePercentage60dInCurrency ?? 0,
      priceChangePercent: usdMarket.priceChangePercentage24hInCurrency ?? 0,
      lastUpdated: coin.lastUpdated ?? DateTime.now(),
      markets: markets,
      lastWeekPrices: lastWeekPrices,
    );
  }

  String get priceStr => formatInPrice(price);

  String get highestStr => formatInPrice(highest, 2);

  String get lowestStr => formatInPrice(lowest, 2);

  String get marketCapStr => formatInBillions(marketCap);

  String get volumeStr => formatInBillions(volume);

  String get supplyStr => formatInMillions(currSupply);

  String get maxSupplyStr => formatInMillions(maxSupply);

  String get priceChangeStr {
    String str = priceChange.toString();
    if (str.length >= 6) {
      str = str.substring(0, 6);
      if (str == '0.0000' || str == '-0.000') return '~ 0';
    }
    return priceChange > 0 ? '+$str' : str;
  }

  String get priceChangePercentStr {
    String str = priceChangePercent.toStringAsFixed(2);
    if (str == '0.00' || str == '-0.00') return '~ 0';
    return priceChangePercent > 0 ? '+$str%' : '$str%';
  }

  Color get trendColor {
    return priceChangePercent < 0 ? Colors.red : Colors.green;
  }

  static final usdCoin = CoinData(
    id: 'dollars',
    name: 'USD',
    symbol: 'usd',
    image: AppConstants.usdIconUrl,
    price: 1,
    highest: 0,
    lowest: 0,
    volume: 0,
    marketCap: 0,
    currSupply: 0,
    maxSupply: 0,
    priceChange: 0,
    priceChangePercent: 0,
    lastUpdated: DateTime.now(),
    markets: const {},
    lastWeekPrices: const [],
  );
}
