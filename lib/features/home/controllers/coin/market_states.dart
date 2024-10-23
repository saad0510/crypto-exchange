import '../../../../core/errors/failures.dart';
import '../../entities/coin_data.dart';
import '../../entities/nft_data.dart';

abstract class MarketState {
  CoinsFailure? error;
  MarketState({this.error});
}

class MarketEmptyState extends MarketState {
  MarketEmptyState({super.error});
}

class MarketLoadingState extends MarketState {
  MarketLoadingState({super.error});
}

class MarketErrorState extends MarketState {
  MarketErrorState({required super.error});
}

class MarketLoadedState extends MarketState {
  final Map<String, CoinData> coins; // id:coin
  final List<NFTData> nfts;

  MarketLoadedState({
    required this.coins,
    required this.nfts,
    super.error,
  });

  MarketLoadedState copyWith({
    Map<String, CoinData>? coins,
    List<NFTData>? nfts,
  }) {
    return MarketLoadedState(
      coins: coins ?? this.coins,
      nfts: nfts ?? this.nfts,
    );
  }
}
