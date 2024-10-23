import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/routes.dart';
import '../../../core/extensions/context_ext.dart';
import '../controllers/auth/auth_controller.dart';
import '../controllers/auth/auth_state.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  late final controller = context.read<AuthController>();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void initState() {
    handleState();
    controller.addListener(handleState);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(handleState);
    super.dispose();
  }

  void handleState() async {
    if (!context.mounted) return;

    final state = controller.state;
    final replaceAll = context.replaceAll;

    await Future.delayed(Duration.zero);

    if (state is AuthEmptyState) {
      replaceAll(AppRoutes.auth);
      return;
    }

    if (state is AuthLoadedState) {
      final isVerifedEmail = await controller.authRepo.isVerified;
      if (!isVerifedEmail) {
        replaceAll(AppRoutes.emailVerify);
      } else if (!state.hasPhone) {
        replaceAll(AppRoutes.phoneInput);
      } else {
        replaceAll(AppRoutes.navigation);
      }
    }
  }
}
