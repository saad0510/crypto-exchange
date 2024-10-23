import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/assets.dart';
import '../../../app/routes.dart';
import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/extensions/text_ext.dart';
import '../controllers/auth/auth_controller.dart';
import '../widgets/force_back_button.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  late Timer timer;
  late final controller = context.read<AuthController>();
  final timeout = const Duration(seconds: 3);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Email Verification"),
          leading: const ForceBackButton(),
        ),
        body: Padding(
          padding: AppPaddings.normalXY,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'Please check your email and click on the link to verify your account.',
                style: context.textTheme.headlineSmall!.regular,
                textAlign: TextAlign.center,
              ),
              AppSizes.maxY,
              Expanded(
                flex: 2,
                child: Image.asset(AppAssets.emailVerify),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => controller.authRepo.sendVerificationEmail(),
                child: const Text('Resend Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendVerificationEmail() async {
    final showErrorSnackBar = context.showErrorSnackBar;
    final res = await controller.authRepo.sendVerificationEmail();
    res.whenError(
      (error) => showErrorSnackBar(message: error.message),
    );
  }

  void checkStatus() {
    timer = Timer.periodic(
      timeout,
      (timer) async {
        final replaceAll = context.replaceAll;
        final isVerified = await controller.authRepo.isVerified;
        if (isVerified) {
          timer.cancel();
          replaceAll(AppRoutes.setup);
        }
      },
    );
  }

  @override
  void initState() {
    sendVerificationEmail();
    checkStatus();
    return super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
