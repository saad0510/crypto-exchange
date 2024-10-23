import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/constants.dart';
import '../../../app/sizes.dart';
import '../../../app/theme/colors.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/utils/form_validations.dart';
import '../../auth/controllers/auth/auth_controller.dart';
import '../../auth/widgets/auth_text_field.dart';
import '../../home/entities/coin_data.dart';
import '../../wallet/controller/wallet/wallet_controller.dart';
import '../../wallet/widgets/coin_quantity_field.dart';
import '../entities/stak_data.dart';

class AddStakScreen extends StatefulWidget {
  const AddStakScreen({super.key});

  @override
  State<AddStakScreen> createState() => _AddStakScreenState();
}

class _AddStakScreenState extends State<AddStakScreen> {
  final formKey = GlobalKey<FormState>();
  late final wallet = context.read<WalletController>();

  int months = 0;
  double amount = 0, available = double.infinity;
  CoinData coin = CoinData.usdCoin;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("New Staking"),
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
                        'Enter the coin details and\nduration of your staking',
                        style: context.textTheme.displayLarge,
                      ),
                      const Spacer(),
                      AuthTextField(
                        label: "Duration",
                        hint: "Number of Months",
                        onSubmit: (x) => months = int.parse(x.trim()),
                        validator: FormValidations.number,
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
                          child: const Text("Create Staking"),
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

  void addStak() async {
    final pop = context.pop;
    context.showLoadingIndicator();

    final currentUid = context.read<AuthController>().user.uid;
    final now = DateTime.now();
    final checkPoints = List.generate(
      months,
      (i) => now.add(
        Duration(days: 30 * (i + 1)),
      ),
    );

    final i = math.Random().nextInt(3);
    final rate = AppConstants.stakRates[i];

    final stak = StakData(
      stkId: '',
      ownerId: currentUid,
      coinId: coin.id,
      rate: rate,
      amount: amount,
      checkPoints: checkPoints,
    );
    await wallet.addStak(stak);
    pop();
    pop();
  }

  void submit() {
    if (!mounted) return;
    final validated = formKey.currentState!.validate();
    if (!validated) return;
    formKey.currentState!.save();
    addStak();
  }

  void setAmount(String x) {
    amount = double.tryParse(x) ?? amount;
    available = (wallet.wallet.coins[coin.id] ?? 0).toDouble();
    setState(() {});
  }
}
