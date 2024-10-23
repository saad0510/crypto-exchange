enum AppCoins {
  bitcoin,
  ethereum,
  tether,
  binanceCoin,
  usdCoin,
  ripple,
  cardano,
  dogeCoin,
  stakedEther,
  maticNetwork;

  static final toCoinId = {
    bitcoin: 'bitcoin',
    ethereum: 'ethereum',
    tether: 'tether',
    binanceCoin: 'binancecoin',
    usdCoin: 'usd-coin',
    ripple: 'ripple',
    cardano: 'cardano',
    dogeCoin: 'dogecoin',
    stakedEther: 'staked-ether',
    maticNetwork: 'matic-network',
  };

  String get coinId => AppCoins.toCoinId[this] ?? '';
}
