import '../../auth/controllers/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/extensions/text_ext.dart';
import '../../../core/utils/form_validations.dart';
import '../../../core/utils/price_formatting.dart';
import '../../auth/widgets/auth_text_field.dart';
import '../../home/entities/coin_data.dart';
import '../../home/widgets/price_text.dart';
import '../../wallet/controller/wallet/wallet_controller.dart';
import '../entities/peer_offer.dart';

class BuyOfferSheet extends StatefulWidget {
  const BuyOfferSheet({
    super.key,
    required this.offer,
    required this.coin,
  });

  final PeerOffer offer;
  final CoinData coin;

  @override
  State<BuyOfferSheet> createState() => _BuyOfferSheetState();
}

class _BuyOfferSheetState extends State<BuyOfferSheet> {
  double amount = 0;
  late final wallet = context.watch<WalletController>();
  late final maxUsds = wallet.wallet.coins[CoinData.usdCoin.id] ?? 0;

  @override
  Widget build(BuildContext context) {
    final total = amount * widget.offer.price;
    final uid = context.read<AuthController>().user.uid;

    return SimpleDialog(
      contentPadding: AppPaddings.normalXY,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      title: SizedBox(
        width: context.width * 0.7,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${widget.offer.ownerId == uid ? 'Restore' : 'Buy'} one ${widget.coin.name} for  ",
              style: context.textTheme.headlineMedium!.regular,
            ),
            PriceText(formatInPrice(widget.offer.price), size: 24),
          ],
        ),
      ),
      children: [
        AppSizes.largeY,
        AuthTextField(
          autofocus: true,
          label: "Quantity",
          hint: "Amount of ${widget.coin.name} (Max ${widget.offer.amount})",
          validator: FormValidations.price,
          keyboardType: TextInputType.number,
          onSubmit: (x) {},
          onChange: (x) {
            setState(() => amount = double.tryParse(x) ?? amount);
          },
        ),
        AppSizes.largeY,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total",
              style: context.textTheme.displaySmall,
            ),
            PriceText(formatInPrice(total)),
          ],
        ),
        AppSizes.maxY,
        if (amount > widget.offer.amount)
          ElevatedButton(
            onPressed: null,
            child: Text("Amount exceeds ${widget.offer.amount}"),
          )
        else if (total > maxUsds)
          ElevatedButton(
            onPressed: null,
            child: Text("You only have $maxUsds USDs"),
          )
        else
          ElevatedButton(
            onPressed: buy,
            child: const Text("Buy"),
          ),
      ],
    );
  }

  void buy() async {
    final pop = context.pop;
    context.showLoadingIndicator();
    await wallet.buyOffer(widget.offer, amount);
    pop();
    pop();
  }
}
