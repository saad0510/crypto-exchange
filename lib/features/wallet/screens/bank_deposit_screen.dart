import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/utils/form_validations.dart';
import '../../auth/controllers/auth/auth_controller.dart';
import '../../auth/widgets/auth_text_field.dart';
import '../controller/wallet/wallet_controller.dart';
import '../entities/bank_transaction_data.dart';
import 'pick_images_screen.dart';

class BankDepositScreen extends StatefulWidget {
  const BankDepositScreen({super.key});

  @override
  State<BankDepositScreen> createState() => _BankDepositScreenState();
}

class _BankDepositScreenState extends State<BankDepositScreen> {
  final formKey = GlobalKey<FormState>();
  late final auth = context.read<AuthController>();
  late final user = auth.user;

  String accountName = '';
  String bankName = '';
  String bankIBAN = '';
  int transactionId = 0;
  double amount = 0;
  File? imgFile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bank Deposit'),
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
                        label: "Account Name",
                        hint: user.name,
                        initialValue: user.name,
                        onSubmit: (x) => accountName = x.trim(),
                        validator: FormValidations.name,
                        keyboardType: TextInputType.name,
                      ),
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
                      Row(
                        children: [
                          Expanded(
                            child: AuthTextField(
                              label: "Transaction ID",
                              hint: '1234',
                              onSubmit: (x) => transactionId = int.parse(x),
                              validator: FormValidations.price,
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          AppSizes.normalX,
                          AppSizes.normalX,
                          Expanded(
                            child: AuthTextField(
                              label: "Amount",
                              hint: 'In USD',
                              onSubmit: (x) => amount = double.parse(x),
                              validator: FormValidations.price,
                              keyboardType: TextInputType.name,
                            ),
                          ),
                        ],
                      ),
                      AppSizes.largeY,
                      imgFile != null
                          ? Image.file(
                              imgFile!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              height: 200,
                            )
                          : TextButton.icon(
                              onPressed: () {
                                context.to(
                                  PickImagesScreen(
                                    title: 'Pick a receipt image of your bank transaction',
                                    onSubmit: (x) => setState(() => imgFile = x.first),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add Receipt'),
                            ),
                      AppSizes.largeY,
                      AppSizes.largeY,
                      const Spacer(),
                      ElevatedButton(
                        onPressed: submit,
                        child: const Text('Deposit'),
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
    if (imgFile == null) return;

    final controller = context.read<WalletController>();
    final pop = context.pop;
    final showSnackBar = context.showSnackBar;
    context.showLoadingIndicator();

    final result = await controller.walletRepo.uploadReceipt(imgFile!);
    final receipt = result.tryGetSuccess() ?? '';

    final data = BankTransactionData(
      userId: user.uid,
      accountName: accountName,
      bankName: bankName,
      bankIBAN: bankIBAN,
      transactionId: transactionId,
      amount: amount,
      isPending: true,
      createdAt: DateTime.now(),
      receiptImg: receipt,
    );

    await controller.walletRepo.depositTransaction(data);
    pop();
    pop();
    showSnackBar(message: 'Submitted for approval');
  }
}
