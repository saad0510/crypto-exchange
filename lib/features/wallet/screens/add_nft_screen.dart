import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/utils/app_coins.dart';
import '../../../core/utils/form_validations.dart';
import '../../auth/widgets/auth_text_field.dart';
import '../../home/controllers/coin/market_controller.dart';
import '../../home/entities/coin_data.dart';
import '../controller/wallet/wallet_controller.dart';
import '../widgets/coins_exchange_field.dart';
import '../widgets/nft_image_picker.dart';

class AddNFTScreen extends StatefulWidget {
  const AddNFTScreen({super.key});

  @override
  State<AddNFTScreen> createState() => _AddNFTScreenState();
}

class _AddNFTScreenState extends State<AddNFTScreen> {
  late final market = context.watch<MarketController>();
  final formKey = GlobalKey<FormState>();

  String title = '';
  String description = '';
  double price = 1;
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("New NFT"),
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: AppPaddings.normalXY,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      Center(
                        child: NFTImagePicker(
                          onChange: (file) => imageFile = file,
                        ),
                      ),
                      const Spacer(flex: 2),
                      AuthTextField(
                        label: "Title",
                        hint: "A Rare Football",
                        onSubmit: (x) => title = x.trim(),
                        validator: FormValidations.name,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      AppSizes.maxY,
                      AuthTextField(
                        label: "Description",
                        hint: "Some descriptive text",
                        onSubmit: (x) => description = x.trim(),
                        validator: FormValidations.name,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      AppSizes.maxY,
                      Text(
                        'Price',
                        style: context.textTheme.bodyLarge,
                      ),
                      AppSizes.largeY,
                      CoinsExchangeField(
                        coin1: market.getCoin(AppCoins.ethereum),
                        coin2: CoinData.usdCoin,
                        onChange: (eths, usds) => price = eths,
                      ),
                      AppSizes.maxY,
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => submit(),
                        child: const Text("Create NFT"),
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

  void submit() {
    if (!mounted) return;
    final validated = formKey.currentState!.validate();
    if (!validated) return;
    formKey.currentState!.save();
    addNFT();
  }

  void addNFT() async {
    final pop = context.pop;
    context.showLoadingIndicator();
    await context.read<WalletController>().addNft(
          title: title,
          description: description,
          priceInEths: price,
          image: imageFile!,
        );
    pop();
    pop();
  }
}
