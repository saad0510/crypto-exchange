import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';

class AddStakButton extends StatelessWidget {
  const AddStakButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () => context.push(AppRoutes.addStak),
      style: TextButton.styleFrom(
        padding: AppPaddings.normalX,
        textStyle: context.textTheme.bodyLarge,
      ),
    );
  }
}
