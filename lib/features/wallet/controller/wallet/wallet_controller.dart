import 'dart:io';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_coins.dart';
import '../../../../core/utils/base_change_notifier.dart';
import '../../../auth/entities/user_data.dart';
import '../../../home/entities/coin_data.dart';
import '../../../home/entities/nft_data.dart';
import '../../../home/repositories/nfts_repo.dart';
import '../../../p2p/entities/peer_offer.dart';
import '../../../p2p/repositories/p2p_repo.dart';
import '../../../staking/entities/stak_data.dart';
import '../../../staking/repositories/stak_repo.dart';
import '../../entities/wallet_data.dart';
import '../../repositories/wallet_repo.dart';
import 'wallet_state.dart';

class WalletController extends BaseChangeNotifier<WalletState> {
  final StakRepo stakRepo;
  final NFTsRepo nfTRepo;
  final P2PRepo p2pRepo;
  final WalletRepo walletRepo;

  List<StakData> staks = [];
  List<PeerOffer> offers = [];

  WalletController({
    required this.walletRepo,
    required this.nfTRepo,
    required this.stakRepo,
    required this.p2pRepo,
  }) : super(WalletEmptyState());

  UserData get user => (state as WalletLoadedState).user;

  WalletData get wallet => (state as WalletLoadedState).wallet;

  double get balance {
    final s = state;
    if (s is WalletLoadedState) return s.wallet.usd.toDouble();
    return 0;
  }

  String get address {
    final s = state;
    if (s is WalletLoadedState) return s.wallet.address;
    return '';
  }

  List<PeerOffer> get myOffers => offers //
      .where((offer) => offer.ownerId == user.uid)
      .toList();

  Future<void> connectMetaMask(double usds, String address) async {
    await walletRepo.changeAddress(user.uid, address);
    await walletRepo.depositAmount(user.uid, CoinData.usdCoin.id, usds);
    wallet.coins[CoinData.usdCoin.id] = (wallet.coins[CoinData.usdCoin.id] ?? 0) + usds;
    wallet.address = address;
    wallet.updateDolalrs();
    notifyListeners();
  }

  void loadState(UserData user) async {
    final res = await walletRepo.fetchWallet(user.uid);
    res.when(
      (wallet) => state = WalletLoadedState(
        user: user,
        wallet: wallet,
      ),
      (error) => state = WalletErrorState(error: error),
    );
    stakRepo.getStaksOf(user.uid).listen(
      (stakList) {
        staks = stakList;
        notifyListeners();
      },
    );
    p2pRepo.getOffers().listen(
      (offerList) {
        offers = offerList;
        notifyListeners();
      },
    );
  }

  Future<void> swapCoins(
    String srcId,
    double srcAmount,
    String targetId,
    double targetAmount,
  ) async {
    await walletRepo.depositAmount(user.uid, srcId, -srcAmount);
    await walletRepo.depositAmount(user.uid, targetId, targetAmount);
    wallet.coins[srcId] = (wallet.coins[srcId] ?? 0) - srcAmount;
    wallet.coins[targetId] = (wallet.coins[targetId] ?? 0) + targetAmount;
    wallet.updateDolalrs();
    notifyListeners();
  }

  Future<void> addNft({
    required String title,
    required String description,
    required double priceInEths,
    required File image,
  }) async {
    final imgRes = await nfTRepo.uploadNFTImage(image);
    if (imgRes.isError()) {
      final errMsg = imgRes.tryGetError()!.message;
      state.error = WalletFailure(errMsg);
      notifyListeners();
      return;
    }
    final imageUrl = imgRes.tryGetSuccess()!;
    final nft = NFTData.essentials(
      title: title,
      description: description,
      ownerId: user.uid,
      price: priceInEths,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );
    final nftRes = await nfTRepo.addNFt(nft);
    if (nftRes.isError()) {
      final errMsg = imgRes.tryGetError()!.message;
      final error = WalletFailure(errMsg);
      state = WalletErrorState(error: error);
    }
  }

  Future<void> addStak(StakData stak) async {
    await walletRepo.depositAmount(user.uid, stak.coinId, -stak.amount);
    await stakRepo.addStak(stak);
    wallet.coins[stak.coinId] = (wallet.coins[stak.coinId] ?? 0) - stak.amount;
    wallet.updateDolalrs();
    notifyListeners();
  }

  Future<void> buyNft(NFTData nft) async {
    final ethId = AppCoins.toCoinId[AppCoins.ethereum]!;
    await walletRepo.depositAmount(nft.ownerId, ethId, nft.price);
    await walletRepo.depositAmount(user.uid, ethId, -nft.price);
    wallet.coins[ethId] = (wallet.coins[ethId] ?? 0) - nft.price;
    await nfTRepo.changeOwnership(nft.nftId, user.uid);
    wallet.updateDolalrs();
    notifyListeners();
  }

  Future<void> sellNft(NFTData nft, double price) async {
    final newNft = nft.copyWith(available: true, price: price);
    await nfTRepo.updateNft(newNft);
    notifyListeners();
  }

  bool checkStak(StakData stak) {
    final date = stak.checkPoints.first;
    final daysLeft = DateTime.now().difference(date).inDays;
    return daysLeft >= 0;
  }

  Future<void> reduceStak(StakData stak) async {
    stak.checkPoints.removeAt(0);
    await walletRepo.depositAmount(user.uid, stak.coinId, stak.profit);
    wallet.coins[stak.coinId] = (wallet.coins[stak.coinId] ?? 0) + stak.profit;
    wallet.updateDolalrs();
    notifyListeners();

    if (stak.checkPoints.isEmpty) {
      await stakRepo.deleteStak(stak.stkId);
    } else {
      await stakRepo.updateStak(stak);
    }
  }

  Future<void> addOffer(PeerOffer offer) async {
    await p2pRepo.addOffer(offer);
    await walletRepo.depositAmount(user.uid, offer.coinId, -offer.amount);
    wallet.coins[offer.coinId] = (wallet.coins[offer.coinId] ?? 0) - offer.amount;
    wallet.updateDolalrs();
    notifyListeners();
  }

  Future<void> buyOffer(PeerOffer offer, double amount) async {
    await p2pRepo.reduceOffer(offer, amount);
    final usds = amount * offer.price;
    if (offer.ownerId != user.uid) {
      await walletRepo.depositAmount(user.uid, CoinData.usdCoin.id, -usds);
      wallet.coins[CoinData.usdCoin.id] = (wallet.coins[CoinData.usdCoin.id] ?? 0) - usds;
    }
    await walletRepo.depositAmount(user.uid, offer.coinId, amount);
    await walletRepo.depositAmount(offer.ownerId, CoinData.usdCoin.id, usds);
    wallet.coins[offer.coinId] = (wallet.coins[offer.coinId] ?? 0) + amount;
    wallet.updateDolalrs();
    notifyListeners();
  }

  Future<void> deleteOffer(PeerOffer offer) async {}
}
