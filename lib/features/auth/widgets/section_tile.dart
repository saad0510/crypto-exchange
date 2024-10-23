import 'package:flutter/material.dart';

import '../../../core/extensions/context_ext.dart';

class SectionTile extends StatelessWidget {
  const SectionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: 8,
      minVerticalPadding: 20,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      dense: true,
      visualDensity: VisualDensity.compact,
      iconColor: context.primaryColor,
      tileColor: context.backgroundColor,
      leading: Icon(icon),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 17,
          height: 0,
          color: context.contrastColor,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded),
    );
  }
}
