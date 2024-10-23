import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/utils/app_coins.dart';
import '../../../core/utils/form_validations.dart';
import '../../auth/widgets/auth_text_field.dart';
import '../../wallet/controller/wallet/wallet_controller.dart';
import '../entities/nft_data.dart';
import 'custom_dialog.dart';

class NftTileControls extends StatelessWidget {
  const NftTileControls({super.key, required this.nft});

  final NFTData nft;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            style: context.textTheme.displayLarge?.copyWith(height: 0),
            text: '${nft.price.toStringAsFixed(1)} ',
            children: const [
              TextSpan(
                text: 'ETH',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 40,
          width: 100,
          child: nft.available ? NFTBuyButton(nft: nft) : NFTSellButton(nft: nft),
        ),
      ],
    );
  }
}

class NFTBuyButton extends StatelessWidget {
  const NFTBuyButton({super.key, required this.nft});

  final NFTData nft;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showConfirmDialog(context),
      style: ElevatedButton.styleFrom(
        padding: AppPaddings.smallY,
        textStyle: const TextStyle(fontSize: 16),
      ),
      child: const Text("Buy"),
    );
  }

  void showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: "Are you sure you want to buy this nft?",
          actionText: "Confirm",
          onPressed: (ctx) {
            final wallet = ctx.read<WalletController>();
            final ethId = AppCoins.toCoinId[AppCoins.ethereum];
            final available = wallet.wallet.coins[ethId] ?? 0;
            if (available < nft.price) {
              ctx.pop();
              context.showErrorSnackBar(message: "You only have $available Eths");
              return;
            }
            ctx.showLoadingIndicator(true);
            wallet.buyNft(nft).then((_) => ctx.pop()).then((_) => context.pop());
          },
        );
      },
    );
  }
}

class NFTSellButton extends StatelessWidget {
  const NFTSellButton({super.key, required this.nft});

  final NFTData nft;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showConfirmDialog(context),
      style: ElevatedButton.styleFrom(
        padding: AppPaddings.smallY,
        textStyle: const TextStyle(fontSize: 16),
      ),
      child: const Text("Sell"),
    );
  }

  void showConfirmDialog(BuildContext context) {
    double price = 0;

    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          contentPadding: AppPaddings.normalXY,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          children: [
            AuthTextField(
              label: 'Selling Price',
              hint: 'The price for which you want to sell this nft',
              onSubmit: (x) {},
              onChange: (x) => price = double.tryParse(x) ?? 0,
              validator: FormValidations.price,
              keyboardType: TextInputType.number,
            ),
            AppSizes.maxY,
            ElevatedButton(
              onPressed: () {
                ctx.showLoadingIndicator(true);
                ctx
                    .read<WalletController>() //
                    .sellNft(nft, price)
                    .then((_) => ctx.pop())
                    .then((_) => ctx.pop());
              },
              child: const Text('Sell'),
            ),
          ],
        );
      },
    );
  }
}
