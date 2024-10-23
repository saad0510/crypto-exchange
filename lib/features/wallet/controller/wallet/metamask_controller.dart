import 'package:http/http.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/web3dart.dart';

import '../../../../app/constants.dart';
import '../../../../core/utils/base_change_notifier.dart';

class MetaMaskController extends BaseChangeNotifier<SessionStatus> {
  static const chainId = 97;
  static const bridge = 'https://bridge.walletconnect.org';
  static const rpcUrl = 'https://data-seed-prebsc-1-s1.binance.org:8545/';

  final connector = WalletConnect(
    bridge: bridge,
    clientMeta: const PeerMeta(
      name: AppConstants.title,
      url: bridge,
      description: 'Connect to transfer your assets',
    ),
  );

  MetaMaskController()
      : super(
          SessionStatus(chainId: chainId, accounts: []),
        );

  bool get isConnected => connector.connected;

  Future<void> connect() async {
    if (connector.connected) return;
    state = await connector.connect(
      chainId: chainId,
      onDisplayUri: (uri) => launchUrlString(uri),
    );
  }

  Future<double> get balance async {
    if (state.accounts.isEmpty) return 0;
    final hexAddr = state.accounts.first;
    final client = Web3Client(rpcUrl, Client());
    final addr = EthereumAddress.fromHex(hexAddr);
    final balance = await client.getBalance(addr);
    return balance.getValueInUnit(EtherUnit.ether);
  }

  String get address {
    if (state.accounts.isEmpty) return '';
    return state.accounts.first;
  }

  Future<void> reset() async {
    await connector.close(forceClose: true);
    await connector.killSession();
    await connector.rejectSession();
    await connector.sessionStorage?.removeSession();
  }
}
