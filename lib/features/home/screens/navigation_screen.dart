import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/routes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../auth/controllers/auth/auth_controller.dart';
import '../../auth/controllers/auth/auth_state.dart';
import '../../p2p/screens/p2p_screen.dart';
import '../../staking/screens/stak_screen.dart';
import 'home_screen.dart';
import 'setttings_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int selected = 0;

  final bodies = const [
    HomeScreen(),
    P2PScreen(),
    StakScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodies[selected],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (i) => setState(() => selected = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.group),
            label: 'P2P',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments),
            label: 'Staking',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  late final auth = context.read<AuthController>();

  @override
  void initState() {
    auth.addListener(handleState);
    super.initState();
  }

  @override
  void dispose() {
    auth.removeListener(handleState);
    super.dispose();
  }

  void handleState() {
    if (!mounted) return;
    final state = auth.state;
    if (state is AuthEmptyState) {
      context.replaceAll(AppRoutes.auth);
    } else if (state is AuthErrorState) {
      context.showErrorSnackBar(message: state.failure.message);
    }
  }
}
