import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/utils/form_validations.dart';
import '../../../injections.dart';
import '../controllers/auth/auth_controller.dart';
import '../widgets/auth_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String email = '';
  late final initialEmail = context.read<AuthController>().user.email;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: AppPaddings.normalXY,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSizes.largeY,
                    Text(
                      "Reset Password",
                      style: context.textTheme.displayLarge,
                    ),
                    AppSizes.normalY,
                    Text(
                      "You will receive a reset email at the provided email address. Follow the instructions mentioned in that email to reset your password",
                      style: context.textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    AuthTextField(
                      label: 'Email',
                      initialValue: initialEmail,
                      validator: FormValidations.email,
                      hint: 'abc@gmail.com',
                      onChange: (x) => email = x,
                      onSubmit: (x) {},
                    ),
                    const Spacer(flex: 3),
                    ElevatedButton(
                      onPressed: () async {
                        final pop = context.pop;
                        context.showLoadingIndicator();
                        await Injections.instance.authRepo.sendResetEmail(email);
                        pop();
                        pop();
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
