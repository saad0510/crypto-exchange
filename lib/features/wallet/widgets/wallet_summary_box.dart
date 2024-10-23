import 'package:click_to_copy/click_to_copy.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/constants.dart';
import '../../../app/routes.dart';
import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/extensions/text_ext.dart';
import '../../../core/utils/price_formatting.dart';
import '../../home/widgets/price_text.dart';
import '../controller/wallet/wallet_controller.dart';

class WalletSummaryBox extends StatelessWidget {
  const WalletSummaryBox({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletController>();

    return Column(
      children: [
        ListTile(
          contentPadding: AppPaddings.zero,
          title: Text(
            'Balance',
            style: context.textTheme.bodyLarge,
          ),
          subtitle: Hero(
            tag: AppConstants.walletBalanceTag,
            child: PriceText(
              formatInPrice(wallet.balance),
            ),
          ),
          trailing: IconButton(
            tooltip: 'Go to Wallet',
            onPressed: () => context.push(AppRoutes.wallet),
            iconSize: 32,
            icon: const Icon(Icons.wallet),
          ),
        ),
        if (wallet.address.isNotEmpty) AppSizes.largeY,
        if (wallet.address.isNotEmpty)
          ListTile(
            tileColor: context.backgroundColor,
            dense: true,
            visualDensity: VisualDensity.compact,
            contentPadding: AppPaddings.smallXY,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            title: Text(
              'Your Address',
              style: context.textTheme.bodyLarge,
            ),
            subtitle: Text(
              wallet.address,
              style: context.textTheme.titleLarge!.regular,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              tooltip: 'Copy',
              onPressed: () => ClickToCopy.copy(wallet.address) //
                  .then(
                (_) => context.showSnackBar(message: "Wallet address copied"),
              ),
              iconSize: 32,
              icon: const Icon(Icons.copy_rounded),
            ),
          ),
      ],
    );
  }
}
