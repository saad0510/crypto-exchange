import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/routes.dart';
import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/utils/form_validations.dart';
import '../controllers/auth/auth_controller.dart';
import '../controllers/auth/auth_state.dart';
import '../widgets/auth_text_field.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  late final controller = context.read<AuthController>();
  final formKey = GlobalKey<FormState>();

  String phone = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Form(
                key: formKey,
                child: Padding(
                  padding: AppPaddings.normalXY,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Hey\n${controller.user.name}",
                        style: context.textTheme.displayLarge,
                      ),
                      AppSizes.normalY,
                      Text(
                        "We need your phone number to finish creating your account",
                        style: context.textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      Padding(
                        padding: AppPaddings.maxY,
                        child: AuthTextField(
                          label: "Phone",
                          hint: "+9231234567890",
                          onSubmit: (x) => phone = x,
                          validator: FormValidations.phone,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: submit,
                        child: const Text("Continue"),
                      ),
                      const Spacer(flex: 3),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
    if (!mounted) return;
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    formKey.currentState!.save();
    controller.updatePhoneNumber(phone);
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
