import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/utils/price_formatting.dart';
import '../../home/controllers/coin/market_controller.dart';
import '../../home/widgets/coin_icon.dart';
import '../entities/peer_offer.dart';
import 'buy_offer_sheet.dart';

class P2PListTile extends StatelessWidget {
  const P2PListTile({super.key, required this.offer});

  final PeerOffer offer;

  @override
  Widget build(BuildContext context) {
    final coin = context.watch<MarketController>().getCoinFromId(offer.coinId);
    return ListTile(
      onTap: () => showDialog(
        context: context,
        builder: (_) => BuyOfferSheet(offer: offer, coin: coin),
      ),
      horizontalTitleGap: 24,
      contentPadding: AppPaddings.zero,
      leading: CoinIcon(image: coin.image),
      title: Text(
        coin.name,
        style: context.textTheme.titleLarge?.copyWith(height: 0),
      ),
      subtitle: Text(
        coin.symbol.toUpperCase(),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${formatInPrice(offer.amount)}  left',
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: context.textTheme.headlineMedium!.copyWith(
                height: 0,
                fontWeight: FontWeight.normal,
              ),
              children: [
                TextSpan(
                  text: '\$${formatInPrice(offer.price)}  ',
                ),
                TextSpan(
                  text: '\$${formatInPrice(coin.price)}',
                  style: const TextStyle(decoration: TextDecoration.lineThrough),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
