import 'dart:async';

import 'package:coingecko_api/data/ohlc_info.dart';

import '../../../../core/utils/app_coins.dart';
import '../../../../core/utils/base_change_notifier.dart';
import '../../../../core/utils/cache_repo.dart';
import '../../entities/coin_data.dart';
import '../../entities/nft_data.dart';
import '../../repositories/coins_repo.dart';
import '../../repositories/nfts_repo.dart';
import 'market_states.dart';

class MarketController extends BaseChangeNotifier<MarketState> {
  final CoinsRepo coinRepo;
  final NFTsRepo nfTRepo;
  final CacheRepo cacheRepo;

  StreamSubscription<List<NFTData>>? nftStream;

  MarketController({
    required this.coinRepo,
    required this.nfTRepo,
    required this.cacheRepo,
  }) : super(MarketEmptyState());

  @override
  Future<void> init() async {
    await loadCoins();
    final state = this.state;
    if (state is! MarketLoadedState) return;
    nftStream = nfTRepo
        .allNFTsStream() //
        .listen(
          (nfts) => this.state = state.copyWith(nfts: nfts),
        );
    return super.init();
  }

  List<NFTData> nftsOf(String ownerId) {
    final allNFTs = (state as MarketLoadedState).nfts;
    final userNFTs = allNFTs.where((nft) => nft.ownerId == ownerId && !nft.available);
    return userNFTs.toList();
  }

  List<NFTData> marketNfts(String currentUser) {
    final allNFTs = (state as MarketLoadedState).nfts;
    final userNFTs = allNFTs.where((nft) => nft.available);
    return userNFTs.toList();
  }

  Future<void> loadCoins() async {
    state = MarketLoadingState();
    final coinRes = await coinRepo.fetchCoins();
    if (coinRes.isError()) {
      state = MarketErrorState(error: coinRes.tryGetError());
      return;
    }
    final coins = coinRes.tryGetSuccess()!;
    final coinMap = Map<String, CoinData>.fromIterable(
      coins,
      key: (coin) => coin.id,
    );
    state = MarketLoadedState(coins: coinMap, nfts: []);
    cacheRepo.addCoins(coins);
  }

  Future<List<OHLCInfo>> marketChart(String coinId) async {
    final cache = cacheRepo.getOHLCInfo(coinId);
    if (cache.isSuccess()) return cache.tryGetSuccess()!;

    final res = await coinRepo.coinOHLCData(coinId);
    if (res.isError()) {
      state.error = res.tryGetError();
      notifyListeners();
      return [];
    }

    final ohlcInfo = res.tryGetSuccess()!;
    cacheRepo.addOHLCInfo(coinId, ohlcInfo);
    return ohlcInfo;
  }

  List<CoinData> get coins {
    return (state as MarketLoadedState).coins.values.toList();
  }

  List<CoinData> get allCoins {
    return coins..add(CoinData.usdCoin);
  }

  CoinData getCoin(AppCoins coinId) {
    final key = AppCoins.toCoinId[coinId];
    return (state as MarketLoadedState).coins[key]!;
  }

  CoinData getCoinFromId(String coinId) {
    if (coinId == CoinData.usdCoin.id) return CoinData.usdCoin;
    return (state as MarketLoadedState).coins[coinId]!;
  }

  @override
  void dispose() {
    nftStream?.cancel();
    super.dispose();
  }
}
