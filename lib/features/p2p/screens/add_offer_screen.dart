import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../../app/theme/colors.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/utils/form_validations.dart';
import '../../auth/controllers/auth/auth_controller.dart';
import '../../auth/widgets/auth_text_field.dart';
import '../../home/entities/coin_data.dart';
import '../../wallet/controller/wallet/wallet_controller.dart';
import '../../wallet/widgets/coin_quantity_field.dart';
import '../entities/peer_offer.dart';

class AddOfferScreen extends StatefulWidget {
  const AddOfferScreen({super.key});

  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  final formKey = GlobalKey<FormState>();
  late final wallet = context.read<WalletController>();

  double price = 0;
  double amount = 0, available = double.infinity;
  CoinData coin = CoinData.usdCoin;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("New Offer"),
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Padding(
                padding: AppPaddings.normalXY,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppSizes.maxY,
                      Text(
                        'Enter the coin details and\nyour desired price',
                        style: context.textTheme.displayLarge,
                      ),
                      const Spacer(),
                      AuthTextField(
                        label: "Price in USD",
                        hint: "The desired price of 1 Coin",
                        onSubmit: (x) => price = double.parse(x.trim()),
                        validator: FormValidations.price,
                        keyboardType: TextInputType.number,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      AppSizes.maxY,
                      CoinQuantityField(
                        coin: coin,
                        onChanged: setAmount,
                        onCoinChange: (coin) {
                          setState(() => this.coin = coin);
                          setAmount(amount.toString());
                        },
                      ),
                      AppSizes.maxY,
                      const Spacer(),
                      if (available < amount)
                        ElevatedButton(
                          onPressed: null,
                          child: Text(
                            'You only have $available ${coin.name}s',
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColors.colors.error,
                            ),
                          ),
                        )
                      else
                        ElevatedButton(
                          onPressed: () => submit(),
                          child: const Text("Create Offer"),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addOffer() async {
    final pop = context.pop;
    context.showLoadingIndicator();

    final currentUid = context.read<AuthController>().user.uid;
    final offer = PeerOffer(
      offerId: "",
      ownerId: currentUid,
      coinId: coin.id,
      price: price,
      amount: amount,
    );
    await wallet.addOffer(offer);
    pop();
    pop();
  }

  void submit() {
    if (!mounted) return;
    final validated = formKey.currentState!.validate();
    if (!validated) return;
    formKey.currentState!.save();
    addOffer();
  }

  void setAmount(String x) {
    amount = double.tryParse(x) ?? amount;
    available = (wallet.wallet.coins[coin.id] ?? 0).toDouble();
    setState(() {});
  }
}
