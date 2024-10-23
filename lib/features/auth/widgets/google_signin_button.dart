import 'package:flutter/material.dart';

import '../../../app/assets.dart';
import '../../../app/theme/colors.dart';

class GoogleSigninButton extends StatelessWidget {
  const GoogleSigninButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border.all(color: BlackColor.normal, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Image.asset(AppAssets.googleIcon, height: 18),
        label: const Text("  Continue with Google"),
      ),
    );
  }
}
