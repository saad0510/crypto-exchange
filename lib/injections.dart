import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coingecko_api/coingecko_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

import 'core/utils/cache_repo.dart';
import 'features/auth/controllers/auth/auth_controller.dart';
import 'features/auth/repositories/auth_repo.dart';
import 'features/auth/repositories/user_repo.dart';
import 'features/home/controllers/coin/market_controller.dart';
import 'features/home/repositories/coins_repo.dart';
import 'features/home/repositories/nfts_repo.dart';
import 'features/p2p/repositories/p2p_repo.dart';
import 'features/staking/repositories/stak_repo.dart';
import 'features/wallet/controller/wallet/metamask_controller.dart';
import 'features/wallet/controller/wallet/wallet_controller.dart';
import 'features/wallet/repositories/wallet_repo.dart';
import 'firebase_options.dart';

class Injections {
  Injections._();

  static final instance = Injections._();

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  late final providers = <ChangeNotifierProvider>[
    ChangeNotifierProvider<AuthController>(
      lazy: false,
      create: (_) => AuthController(
        authRepo: authRepo,
        userRepo: userRepo,
      ),
    ),
    ChangeNotifierProvider<MarketController>(
      create: (_) => MarketController(
        coinRepo: coinsRepo,
        nfTRepo: nFTRepo,
        cacheRepo: cacheRepo,
      ),
    ),
    ChangeNotifierProvider<WalletController>(
      create: (_) => WalletController(
        nfTRepo: nFTRepo,
        walletRepo: walletRepo,
        stakRepo: stakRepo,
        p2pRepo: p2pRepo,
      ),
    ),
    ChangeNotifierProvider<MetaMaskController>(
      create: (_) => MetaMaskController(),
    ),
  ];

  late final authRepo = AuthRepo(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
  late final userRepo = UserRepo(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  );
  late final coinsRepo = CoinsRepo(
    geckoApi: CoinGeckoApi(),
  );
  late final nFTRepo = NFTsRepo(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  );
  late final walletRepo = WalletRepo(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  );
  late final stakRepo = StakRepo(
    firestore: FirebaseFirestore.instance,
  );
  late final p2pRepo = P2PRepo(
    firestore: FirebaseFirestore.instance,
  );
  late final cacheRepo = CacheRepo();
}
