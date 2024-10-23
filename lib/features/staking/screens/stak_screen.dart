import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../wallet/controller/wallet/wallet_controller.dart';
import '../widgets/add_stak_button.dart';
import '../widgets/stak_list_view.dart';

class StakScreen extends StatelessWidget {
  const StakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final staks = context.watch<WalletController>().staks;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Staking"),
          actions: const [AddStakButton()],
        ),
        body: SingleChildScrollView(
          padding: AppPaddings.normalXY,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StakListView(staks: staks),
            ],
          ),
        ),
      ),
    );
  }
}
