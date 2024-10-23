import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/errors/failures.dart';
import '../features/auth/controllers/auth/auth_controller.dart';
import '../features/auth/screens/auth_screen.dart';
import '../features/auth/screens/edit_profile_screen.dart';
import '../features/auth/screens/email_verification_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/phone_input_screen.dart';
import '../features/auth/screens/registration_screen.dart';
import '../features/auth/screens/reset_password_screen.dart';
import '../features/auth/screens/setup_screen.dart';
import '../features/home/entities/coin_data.dart';
import '../features/home/screens/coin_detail_screen.dart';
import '../features/home/screens/navigation_screen.dart';
import '../features/p2p/screens/add_offer_screen.dart';
import '../features/staking/screens/add_stak_screen.dart';
import '../features/wallet/controller/wallet/wallet_controller.dart';
import '../features/wallet/screens/add_nft_screen.dart';
import '../features/wallet/screens/bank_deposit_screen.dart';
import '../features/wallet/screens/bank_withdraw_screen.dart';
import '../features/wallet/screens/swap_coins_screen.dart';
import '../features/wallet/screens/wallet_deposit_screen.dart';
import '../features/wallet/screens/wallet_screen.dart';

class AppRoutes {
  static const initial = setup;

  static const setup = 'setup';
  static const auth = 'auth';
  static const login = 'login';
  static const register = 'register';
  static const emailVerify = 'emailVerify';
  static const phoneInput = 'phoneInput';
  static const editProfile = 'editProfile';
  static const navigation = 'navigation';
  static const coinDetail = 'coinDetail';
  static const wallet = 'wallet';
  static const addNFT = 'addNFT';
  static const addStak = 'addStak';
  static const addOffer = 'addOffer';
  static const swapCoins = 'swapCoins';
  static const deposit = 'deposit';
  static const resetPass = 'resetPass';
  static const bankDeposit = 'bankDeposit';
  static const bankWithdraw = 'bankWithdraw';

  static Route<dynamic> onGenerateRoute(RouteSettings route) {
    switch (route.name) {
      case setup:
        return MaterialPageRoute(
          builder: (_) => const SetupScreen(),
        );
      case auth:
        return MaterialPageRoute(
          builder: (_) => const AuthScreen(),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case register:
        return MaterialPageRoute(
          builder: (_) => const RegistrationScreen(),
        );
      case emailVerify:
        return MaterialPageRoute(
          builder: (_) => const EmailVerificationScreen(),
        );
      case phoneInput:
        return MaterialPageRoute(
          builder: (_) => const PhoneInputScreen(),
        );
      case editProfile:
        return MaterialPageRoute(
          builder: (_) => const EditProfileScreen(),
        );
      case navigation:
        return MaterialPageRoute(
          builder: (ctx) {
            final user = ctx.read<AuthController>().user;
            ctx.read<WalletController>().loadState(user);
            return const NavigationScreen();
          },
        );
      case coinDetail:
        return MaterialPageRoute(
          builder: (_) => CoinDetailScreen(coin: route.arguments as CoinData),
        );
      case wallet:
        return MaterialPageRoute(
          builder: (_) => const WalletScreen(),
        );
      case addNFT:
        return MaterialPageRoute(
          builder: (_) => const AddNFTScreen(),
        );
      case addStak:
        return MaterialPageRoute(
          builder: (_) => const AddStakScreen(),
        );
      case addOffer:
        return MaterialPageRoute(
          builder: (_) => const AddOfferScreen(),
        );
      case swapCoins:
        return MaterialPageRoute(
          builder: (_) => const SwapCoinsScreen(),
        );
      case deposit:
        return MaterialPageRoute(
          builder: (_) => const WalletDepositScreen(),
        );
      case resetPass:
        return MaterialPageRoute(
          builder: (_) => const ResetPasswordScreen(),
        );
      case bankDeposit:
        return MaterialPageRoute(
          builder: (_) => const BankDepositScreen(),
        );
      case bankWithdraw:
        return MaterialPageRoute(
          builder: (_) => const BankWithdrawScreen(),
        );
      default:
        throw RouteFailure(route.name ?? "", "route not found");
    }
  }
}
