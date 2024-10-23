import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../home/widgets/section_header.dart';
import '../../wallet/controller/wallet/wallet_controller.dart';
import '../widgets/p2p_list_view.dart';
import '../widgets/sell_coin_peer_button.dart';

class P2PScreen extends StatefulWidget {
  const P2PScreen({super.key});

  @override
  State<P2PScreen> createState() => _P2PScreenState();
}

class _P2PScreenState extends State<P2PScreen> {
  int sectionIndex = 0;
  late final wallet = context.watch<WalletController>();

  @override
  Widget build(BuildContext context) {
    final offers = sectionIndex == 0 ? wallet.offers : wallet.myOffers;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Peer to Peer"),
          actions: const [SellCoinPeerButton()],
        ),
        body: SingleChildScrollView(
          padding: AppPaddings.normalXY,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader(
                filters: const ['All', 'Mine'],
                selected: sectionIndex,
                onSelected: (i) => setState(() => sectionIndex = i),
              ),
              AppSizes.largeY,
              P2PListView(offers: offers),
            ],
          ),
        ),
      ),
    );
  }
}
