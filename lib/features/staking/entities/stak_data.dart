class StakData {
  final String stkId;
  final String ownerId;
  final String coinId;
  final double rate;
  final double amount;
  final List<DateTime> checkPoints;

  const StakData({
    required this.stkId,
    required this.ownerId,
    required this.coinId,
    required this.amount,
    required this.rate,
    required this.checkPoints,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stk_id': stkId,
      'owner_id': ownerId,
      'coin_id': coinId,
      'rate': rate,
      'amount': amount,
      'check_points': checkPoints //
          .map((date) => date.millisecondsSinceEpoch)
          .toList(),
    };
  }

  factory StakData.fromMap(Map<String, dynamic> map) {
    return StakData(
      stkId: map['stk_id'] as String,
      ownerId: map['owner_id'] as String,
      coinId: map['coin_id'] as String,
      rate: map['rate'] as double,
      amount: map['amount'] as double,
      checkPoints: (map['check_points'] as List) //
          .map((ms) => DateTime.fromMillisecondsSinceEpoch(ms))
          .toList(),
    );
  }

  double get profit => rate * amount;
  DateTime get expiryDate => checkPoints.last;

  StakData copyWith({
    String? stkId,
    String? ownerId,
    String? coinId,
    double? rate,
    double? amount,
    List<DateTime>? checkPoints,
  }) {
    return StakData(
      stkId: stkId ?? this.stkId,
      ownerId: ownerId ?? this.ownerId,
      coinId: coinId ?? this.coinId,
      rate: rate ?? this.rate,
      amount: amount ?? this.amount,
      checkPoints: checkPoints ?? this.checkPoints,
    );
  }
}
