import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/routes.dart';
import '../../../core/extensions/context_ext.dart';
import '../controllers/auth/auth_controller.dart';

class ForceBackButton extends StatelessWidget {
  const ForceBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        context.showLoadingIndicator(true);
        context.read<AuthController>().logout();
        context.replaceAll(AppRoutes.setup);
      },
    );
  }
}
