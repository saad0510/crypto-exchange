import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'app/theme/theme.dart';
import 'injections.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Injections.instance.init();
  FlutterNativeSplash.remove();
  runApp(const CoreApp());
}

class CoreApp extends StatelessWidget {
  const CoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      lazy: false,
      child: MultiProvider(
        providers: Injections.instance.providers,
        child: const App(),
      ),
    );
  }
}
