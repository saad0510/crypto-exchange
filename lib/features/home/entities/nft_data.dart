class NFTData {
  final String nftId;
  final String title;
  final String description;
  final String ownerId;
  final String imageUrl;
  final double price;
  final bool available;
  final DateTime createdAt;

  const NFTData({
    required this.nftId,
    required this.title,
    required this.description,
    required this.ownerId,
    required this.imageUrl,
    required this.price,
    required this.available,
    required this.createdAt,
  });

  const NFTData.essentials({
    this.nftId = '',
    required this.title,
    required this.description,
    required this.ownerId,
    required this.imageUrl,
    required this.price,
    this.available = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nft_id': nftId,
      'title': title,
      'description': description,
      'owner_id': ownerId,
      'image_url': imageUrl,
      'price': price,
      'available': available,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory NFTData.fromMap(Map<String, dynamic> map) {
    return NFTData(
      nftId: map['nft_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      ownerId: map['owner_id'] as String,
      imageUrl: map['image_url'] as String,
      price: (map['price'] as num).toDouble(),
      available: map['available'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  NFTData copyWith({
    String? nftId,
    String? title,
    String? description,
    String? ownerId,
    String? imageUrl,
    double? price,
    bool? available,
    DateTime? createdAt,
  }) {
    return NFTData(
      nftId: nftId ?? this.nftId,
      title: title ?? this.title,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      available: available ?? this.available,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
