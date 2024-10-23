import 'dart:developer';

import 'package:coingecko_api/data/ohlc_info.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../app/constants.dart';
import '../../features/home/entities/coin_data.dart';
import '../errors/failures.dart';

class CacheRepo {
  static const coinKey = 'coin-key';
  static const ohlcKey = 'ohlc-key';
  final Map<String, dynamic> _cache = {};

  CacheRepo();

  void addCoins(List<CoinData> coins) {
    for (final coin in coins) {
      addCoin(coin);
    }
  }

  Result<Unit, CacheFailure> addCoin(CoinData coin) {
    return addData<CoinData>(coinKey + coin.id, coin);
  }

  Result<Unit, CacheFailure> addOHLCInfo(String coinId, List<OHLCInfo> ohlc) {
    return addData<List<OHLCInfo>>(ohlcKey + coinId, ohlc);
  }

  Result<Unit, CacheFailure> addData<Type>(String key, Type data) {
    _cache[key] = data;
    return const Success(unit);
  }

  Result<CoinData, CacheFailure> getCoin(String coinId) {
    return getData<CoinData>(coinKey + coinId);
  }

  Result<List<OHLCInfo>, CacheFailure> getOHLCInfo(String coinId) {
    return getData<List<OHLCInfo>>(ohlcKey + coinId);
  }

  Result<Type, CacheFailure> getData<Type>(String key) {
    Type? coin = _cache[key];
    if (coin != null) {
      log('cache hit', name: 'Success');
      return Success(coin);
    }
    log('cache miss', name: 'Warning');
    return const Error(CacheFailure(AppConstants.cacheNotFound));
  }
}
