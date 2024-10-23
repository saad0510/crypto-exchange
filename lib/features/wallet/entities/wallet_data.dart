import '../../../core/utils/app_coins.dart';

class WalletData {
  static const usdKey = 'dollars';

  num usd = 0;
  Map<String, num> coins;
  String address = '';

  WalletData.empty()
      : coins = {},
        usd = 0;

  WalletData({required this.coins, required this.address}) : usd = coins[usdKey]!;

  num operator [](AppCoins coin) {
    final coinId = AppCoins.toCoinId[coin]!;
    return coins[coinId]!;
  }

  bool containsCoin(String id) => coins.containsKey(id);

  void updateDolalrs() => usd = coins[usdKey]!;
}
