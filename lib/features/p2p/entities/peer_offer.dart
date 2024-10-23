class PeerOffer {
  final String offerId;
  final String ownerId;
  final String coinId;
  final double price;
  final double amount;

  const PeerOffer({
    required this.offerId,
    required this.ownerId,
    required this.coinId,
    required this.price,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'offer_id': offerId,
      'owner_id': ownerId,
      'coin_id': coinId,
      'price': price,
      'amount': amount,
    };
  }

  factory PeerOffer.fromMap(Map<String, dynamic> map) {
    return PeerOffer(
      offerId: map['offer_id'] as String,
      ownerId: map['owner_id'] as String,
      coinId: map['coin_id'] as String,
      price: map['price'] as double,
      amount: map['amount'] as double,
    );
  }

  PeerOffer copyWith({
    String? offerId,
    String? ownerId,
    String? coinId,
    double? price,
    double? amount,
  }) {
    return PeerOffer(
      offerId: offerId ?? this.offerId,
      ownerId: ownerId ?? this.ownerId,
      coinId: coinId ?? this.coinId,
      price: price ?? this.price,
      amount: amount ?? this.amount,
    );
  }
}
