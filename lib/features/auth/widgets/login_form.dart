import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/routes.dart';
import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/utils/form_validations.dart';
import '../controllers/auth/auth_controller.dart';
import 'auth_text_field.dart';
import 'text_action_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();

  String email = '';
  String pass = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthTextField(
            label: "Email",
            hint: "Enter your email",
            onSubmit: (x) => email = x.trim(),
            validator: FormValidations.email,
            keyboardType: TextInputType.emailAddress,
          ),
          AppSizes.largeY,
          AuthTextField(
            label: "Password",
            hint: "Enter your password",
            obscure: true,
            onSubmit: (x) => pass = x.trim(),
            validator: FormValidations.password,
            keyboardType: TextInputType.visiblePassword,
          ),
          AppSizes.normalY,
          Align(
            alignment: Alignment.centerRight,
            child: TextActionButton(
              leading: "",
              highlight: "Forgot Password?",
              underline: false,
              onPressed: () => context.push(AppRoutes.resetPass),
            ),
          ),
          AppSizes.normalY,
          AppSizes.normalY,
          const Spacer(),
          ElevatedButton(
            onPressed: () => submit(),
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }

  void submit() {
    if (!mounted) return;
    final validated = formKey.currentState!.validate();
    if (!validated) return;
    formKey.currentState!.save();
    context.read<AuthController>().login(email, pass);
  }
}
