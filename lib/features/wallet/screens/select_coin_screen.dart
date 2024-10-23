import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../home/entities/coin_data.dart';
import '../controller/wallet/wallet_controller.dart';
import '../widgets/wallet_coins_list_view.dart';

class SelectCoinScreen extends StatelessWidget {
  const SelectCoinScreen({
    super.key,
    this.excludeIds = const [],
    required this.onSelected,
  });

  final List<String> excludeIds;
  final void Function(CoinData coin) onSelected;

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletController>();
    final coinIds = wallet.wallet.coins.keys.toList();
    if (excludeIds.isNotEmpty) {
      coinIds.removeWhere((id) => excludeIds.contains(id));
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select a coin'),
        ),
        body: Padding(
          padding: AppPaddings.normalXY,
          child: WalletCoinsListView(
            coinIds: coinIds,
            onTap: (coin) {
              context.pop();
              onSelected(coin);
            },
          ),
        ),
      ),
    );
  }
}
