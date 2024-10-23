import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/utils/form_validations.dart';
import '../../auth/controllers/auth/auth_controller.dart';
import '../../auth/widgets/auth_text_field.dart';
import '../../home/entities/coin_data.dart';
import '../controller/wallet/wallet_controller.dart';

class BankWithdrawScreen extends StatefulWidget {
  const BankWithdrawScreen({super.key});

  @override
  State<BankWithdrawScreen> createState() => _BankWithdrawScreenState();
}

class _BankWithdrawScreenState extends State<BankWithdrawScreen> {
  final formKey = GlobalKey<FormState>();
  late final auth = context.read<AuthController>();
  late final user = auth.user;

  String accountName = '';
  String bankName = '';
  String bankIBAN = '';
  int transactionId = 0;
  double amount = 0;

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletController>().wallet;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bank Withdraw'),
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Padding(
                  padding: AppPaddings.normalXY,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppSizes.largeY,
                      AuthTextField(
                        label: "Bank Name",
                        hint: 'Official full name of bank',
                        onSubmit: (x) => bankName = x.trim(),
                        validator: FormValidations.name,
                        keyboardType: TextInputType.name,
                      ),
                      AppSizes.largeY,
                      AuthTextField(
                        label: "Bank IBAN",
                        hint: 'KW81CBKU00000000000012345601013',
                        onSubmit: (x) => bankIBAN = x.trim(),
                        validator: FormValidations.iban,
                        keyboardType: TextInputType.name,
                      ),
                      AppSizes.largeY,
                      AuthTextField(
                        label: "Amount",
                        hint: 'In USD',
                        onSubmit: (x) => amount = double.parse(x),
                        onChange: (x) async {
                          await Future.delayed(Duration.zero);
                          amount = double.parse(x);
                          setState(() {});
                        },
                        validator: FormValidations.price,
                        keyboardType: TextInputType.name,
                      ),
                      AppSizes.largeY,
                      const Spacer(),
                      if (wallet.usd < amount)
                        ElevatedButton(
                          onPressed: null,
                          child: Text('Only ${wallet.usd} USDs available'),
                        )
                      else
                        ElevatedButton(
                          onPressed: submit,
                          child: const Text('Withdraw'),
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

  void submit() async {
    if (!mounted) return;
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    formKey.currentState!.save();

    final pop = context.pop;
    final showSnackBar = context.showSnackBar;
    context.showLoadingIndicator();
    await context.read<WalletController>().swapCoins(
          CoinData.usdCoin.id,
          amount,
          CoinData.usdCoin.id,
          0,
        );
    pop();
    pop();
    showSnackBar(message: 'Added $amount dollars in wallet');
  }
}
