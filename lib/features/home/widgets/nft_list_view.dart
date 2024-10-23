import 'package:flutter/material.dart';

import '../entities/nft_data.dart';
import 'nft_list_tile.dart';

class NFTListView extends StatelessWidget {
  const NFTListView({super.key, required this.nfts});

  final List<NFTData> nfts;

  @override
  Widget build(BuildContext context) {
    if (nfts.isEmpty) {
      return const Center(
        heightFactor: 10,
        child: Text('No NFTs to show'),
      );
    }

    return ListView.builder(
      itemCount: nfts.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return NFTListTile(nft: nfts[i]);
      },
    );
  }
}
