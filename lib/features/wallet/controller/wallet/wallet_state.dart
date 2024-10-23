import '../../../../core/errors/failures.dart';
import '../../../auth/entities/user_data.dart';
import '../../entities/wallet_data.dart';

abstract class WalletState {
  WalletFailure? error;
  WalletState({this.error});
}

class WalletEmptyState extends WalletState {
  WalletEmptyState({super.error});
}

class WalletLoadingState extends WalletState {
  WalletLoadingState({super.error});
}

class WalletErrorState extends WalletState {
  WalletErrorState({required super.error});
}

class WalletLoadedState extends WalletState {
  final UserData user;
  final WalletData wallet;

  WalletLoadedState({
    required this.user,
    required this.wallet,
  });
}
