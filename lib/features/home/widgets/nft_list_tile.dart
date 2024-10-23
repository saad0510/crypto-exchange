import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../entities/nft_data.dart';
import 'nft_summary.dart';
import 'nft_tile_controls.dart';

class NFTListTile extends StatelessWidget {
  const NFTListTile({super.key, required this.nft});

  final NFTData nft;

  @override
  Widget build(BuildContext context) {
    final imageProvider = NetworkImage(nft.imageUrl);

    return Container(
      height: 250,
      margin: AppPaddings.normalY,
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () => showImageViewer(
                    context,
                    imageProvider,
                    doubleTapZoomable: true,
                    immersive: false,
                    useSafeArea: true,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12)),
                    child: Image.network(
                      nft.imageUrl,
                      width: context.width / 2.5,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: AppPaddings.normalXY.copyWith(bottom: 0),
                    child: NFTSummary(nft: nft),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: AppPaddings.normalXY,
            child: NftTileControls(nft: nft),
          ),
        ],
      ),
    );
  }
}
