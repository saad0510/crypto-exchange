import 'package:flutter/material.dart';

import '../../../app/sizes.dart';
import '../entities/peer_offer.dart';
import 'p2p_list_tile.dart';

class P2PListView extends StatelessWidget {
  const P2PListView({super.key, required this.offers});

  final List<PeerOffer> offers;

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return const Center(
        heightFactor: 10,
        child: Text('No offers to show'),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: offers.length,
      separatorBuilder: (context, i) => AppSizes.smallY,
      itemBuilder: (context, i) {
        return P2PListTile(offer: offers[i]);
      },
    );
  }
}
