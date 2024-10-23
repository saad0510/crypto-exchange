import 'package:flutter/material.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';

class WalletButton extends StatelessWidget {
  const WalletButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: context.backgroundColor,
        padding: AppPaddings.smallXY,
        textStyle: const TextStyle(fontSize: 17, height: 0),
      ),
      icon: Icon(icon, size: 28),
      label: Text(label),
    );
  }
}
