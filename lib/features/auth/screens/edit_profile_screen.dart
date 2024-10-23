import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/constants.dart';
import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/utils/form_validations.dart';
import '../controllers/auth/auth_controller.dart';
import '../controllers/auth/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/user_image_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final controller = context.read<AuthController>();
  late final user = controller.user;
  final formKey = GlobalKey<FormState>();

  String? name, email, phone;
  File? file;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
          actions: [
            IconButton(
              onPressed: submit,
              icon: const Icon(Icons.done),
              color: Colors.greenAccent,
            ),
            AppSizes.smallX,
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Padding(
                  padding: AppPaddings.normalXY,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSizes.normalY,
                      const Spacer(),
                      Center(
                        child: Hero(
                          tag: AppConstants.pfpTag,
                          child: UserImageWidget(
                            imageUrl: user.picUrl,
                            radius: 75,
                            isEditable: true,
                            onChanged: (f) => file = f,
                          ),
                        ),
                      ),
                      AppSizes.maxY,
                      const Spacer(flex: 2),
                      Text(
                        "Your Information",
                        style: context.textTheme.headlineMedium,
                      ),
                      AppSizes.maxY,
                      AuthTextField(
                        label: "Full Name",
                        hint: user.name,
                        onSubmit: (x) => x.trim().isNotEmpty ? name = x : null,
                        validator: FormValidations.name,
                        keyboardType: TextInputType.name,
                      ),
                      AppSizes.largeY,
                      AuthTextField(
                        label: "Email address",
                        hint: user.email,
                        onSubmit: (x) => x.trim().isNotEmpty ? email = x : null,
                        validator: FormValidations.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      AppSizes.largeY,
                      AuthTextField(
                        label: "Phone number",
                        hint: user.phone,
                        onSubmit: (x) => x.trim().isNotEmpty ? phone = x : null,
                        validator: FormValidations.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const Spacer(),
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

  void submit() async {
    if (!mounted) return;
    formKey.currentState!.save();
    final pop = context.pop;

    if (file != null) {
      await controller.updateProfilePic(file!);
    }
    if (email != null) {
      await controller.updateEmailAddr(email!);
    }
    if (name != null || phone != null) {
      await controller.updateUser(
        user.copyWith(name: name, phone: phone),
      );
    }
    pop();
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
    } else if (state is AuthErrorState) {
      context.showErrorSnackBar(message: state.failure.message);
    } else if (controller.miscError != null) {
      context.showErrorSnackBar(message: controller.miscError!.message);
    }
  }
}
