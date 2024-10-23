import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../../core/errors/failures.dart';
import '../../../core/extensions/context_ext.dart';
import '../../auth/controllers/auth/auth_controller.dart';
import '../../wallet/widgets/wallet_summary_box.dart';
import '../controllers/coin/market_controller.dart';
import '../controllers/coin/market_states.dart';
import '../widgets/coin_list_view.dart';
import '../widgets/section_header.dart';
import '../widgets/nft_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final currentUid = context.read<AuthController>().user.uid;
    final controller = context.watch<MarketController>();
    final state = controller.state;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: AppPaddings.normalXY,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const WalletSummaryBox(),
              AppSizes.maxY,
              Text(
                'Market',
                style: context.textTheme.displaySmall,
              ),
              AppSizes.largeY,
              SectionHeader(
                filters: const ['Coins', 'NFTS'],
                selected: selected,
                onSelected: (i) => setState(() => selected = i),
              ),
              AppSizes.largeY,
              Builder(
                builder: (context) {
                  if (state.error != null) {
                    showError(state.error);
                    return Center(
                      heightFactor: 5,
                      child: Text(
                        state.error!.message,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  if (state is MarketErrorState) {
                    return Center(
                      heightFactor: 5,
                      child: Text(
                        state.error!.message,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  if (state is MarketLoadingState) {
                    return const Center(
                      heightFactor: 5,
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is MarketEmptyState) {
                    return const Center(
                      child: Center(
                        child: Text('Market not loaded'),
                      ),
                    );
                  }

                  state as MarketLoadedState;
                  final coins = state.coins.values.toList();
                  final nfts = controller.marketNfts(currentUid);

                  return selected == 0 //
                      ? CoinListView(coins: coins)
                      : NFTListView(nfts: nfts);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showError(CoinsFailure? error) async {
    final showErrorSnackBar = context.showErrorSnackBar;
    await Future.delayed(Duration.zero);
    showErrorSnackBar(message: '${error?.message}');
  }
}
