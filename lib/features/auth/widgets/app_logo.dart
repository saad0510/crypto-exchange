import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/assets.dart';
import '../../../app/theme/theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppTheme>().isDark;

    return Center(
      child: Image.asset(
        isDark ? AppAssets.logoDark : AppAssets.logo,
        alignment: Alignment.center,
        width: 150,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
