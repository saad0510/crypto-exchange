import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/routes.dart';
import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../controllers/auth/auth_controller.dart';
import '../controllers/auth/auth_state.dart';
import '../widgets/app_logo.dart';
import '../widgets/google_signin_button.dart';
import '../widgets/section_divider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final controller = context.read<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: AppPaddings.normalXY,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    const AppLogo(),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => context.push(AppRoutes.login),
                      child: const Text("Login"),
                    ),
                    AppSizes.normalY,
                    ElevatedButton(
                      onPressed: () => context.push(AppRoutes.register),
                      child: const Text("Sign up"),
                    ),
                    const SectionDivider(text: "or"),
                    GoogleSigninButton(
                      onPressed: () => controller.continueWithGoogle(),
                    ),
                    AppSizes.normalY,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    controller.addListener(handleState);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(handleState);
    super.dispose();
  }

  bool isLoading = false;

  void handleState() {
    if (!mounted) return;
    final state = controller.state;

    if (isLoading) {
      context.pop();
      isLoading = false;
    }
    if (state is AuthLoadingState) {
      isLoading = true;
      context.showLoadingIndicator(true);
    } else if (state is AuthLoadedState) {
      context.replaceAll(AppRoutes.setup);
    } else if (state is AuthErrorState) {
      context.showErrorSnackBar(message: state.failure.message);
    }
  }
}
