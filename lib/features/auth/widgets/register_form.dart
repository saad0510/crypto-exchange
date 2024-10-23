import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/sizes.dart';
import '../../../core/utils/form_validations.dart';
import '../controllers/auth/auth_controller.dart';
import '../entities/user_data.dart';
import 'auth_text_field.dart';
import 'text_action_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final formKey = GlobalKey<FormState>();
  bool checked = false;

  String name = '';
  String email = '';
  String password = '';
  String phone = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthTextField(
            label: "Full Name",
            hint: "Enter your full name",
            onSubmit: (x) => name = x.trim(),
            validator: FormValidations.name,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.sentences,
          ),
          AppSizes.largeY,
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
            onSubmit: (x) => password = x.trim(),
            validator: FormValidations.password,
            keyboardType: TextInputType.visiblePassword,
          ),
          AppSizes.largeY,
          AuthTextField(
            label: "Phone number",
            hint: "+923123456789",
            onSubmit: (x) => phone = x.trim(),
            validator: FormValidations.phone,
            keyboardType: TextInputType.phone,
          ),
          AppSizes.largeY,
          CheckboxListTile(
            value: checked,
            onChanged: (x) => setState(() => checked = x ?? false),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: TextActionButton(
              leading: "I agree to the ",
              highlight: "Terms & Conditions and Privacy Policy",
              onPressed: () {},
            ),
          ),
          AppSizes.maxY,
          const Spacer(),
          ElevatedButton(
            onPressed: checked ? () => submit() : null,
            child: const Text("Create account"),
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
    context.read<AuthController>().register(
          UserData(
            uid: '',
            name: name,
            email: email,
            phone: phone,
            picUrl: '',
          ),
          password,
        );
  }
}
