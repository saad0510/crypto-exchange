import 'package:coingecko_api/coingecko_api.dart';
import 'package:coingecko_api/data/ohlc_info.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../app/constants.dart';
import '../../../core/errors/failures.dart';
import '../../../core/utils/app_coins.dart';
import '../entities/coin_data.dart';

class CoinsRepo {
  final CoinGeckoApi geckoApi;

  const CoinsRepo({required this.geckoApi});

  Future<Result<List<CoinData>, CoinsFailure>> fetchCoins() => //
      _catchErrors<List<CoinData>>(
        () async {
          final results = await Future.wait(
            AppCoins.values.map(
              (coin) => geckoApi.coins.getCoinData(
                id: AppCoins.toCoinId[coin]!,
                marketData: true,
                sparkline: true,
                tickers: false,
                communityData: false,
                developerData: false,
                localization: false,
              ),
            ),
          );
          final coins = results.map(
            (res) {
              if (res.data == null) throw Exception(AppConstants.coinApiError);
              return CoinData.fromGeckCoin(res.data!);
            },
          );
          return coins.toList();
        },
      );

  Future<Result<List<OHLCInfo>, CoinsFailure>> coinOHLCData(String coinId) => //
      _catchErrors<List<OHLCInfo>>(
        () async {
          final res = await geckoApi.coins.getCoinOHLC(
            id: coinId,
            vsCurrency: 'usd',
            days: 7,
          );
          if (res.isError) throw Exception(res.errorMessage);
          return res.data;
        },
      );

  Future<Result<ReturnType, CoinsFailure>> _catchErrors<ReturnType>(
    Future<ReturnType> Function() function,
  ) async {
    try {
      return Success(await function());
    } on Exception catch (e) {
      return Error(CoinsFailure(e.toString()));
    }
  }
}
