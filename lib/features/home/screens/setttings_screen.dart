import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/routes.dart';
import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../auth/controllers/auth/auth_controller.dart';
import '../../auth/widgets/section_tile.dart';
import '../../auth/widgets/user_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final user = auth.user;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SingleChildScrollView(
          padding: AppPaddings.normalXY,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UserTile(user: user),
              AppSizes.maxY,
              SectionTile(
                icon: Icons.edit,
                label: 'Edit Profile',
                onTap: () => context.push(AppRoutes.editProfile),
              ),
              AppSizes.normalY,
              SectionTile(
                icon: Icons.dark_mode,
                label: 'Dark Mode',
                onTap: auth.logout,
                trailing: Switch(
                  activeColor: context.primaryColor,
                  value: context.isDarkMode,
                  onChanged: (_) => context.toggleTheme(),
                ),
              ),
              AppSizes.normalY,
              SectionTile(
                icon: Icons.currency_exchange,
                label: 'Swap Coins',
                onTap: () => context.push(AppRoutes.swapCoins),
              ),
              AppSizes.normalY,
              SectionTile(
                icon: Icons.key,
                label: 'Reset Password',
                onTap: () => context.push(AppRoutes.resetPass),
              ),
              AppSizes.normalY,
              SectionTile(
                icon: Icons.logout,
                label: 'Logout',
                onTap: auth.logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
