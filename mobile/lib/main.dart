import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';
import 'config/api_config.dart';
import 'services/cart_service.dart';
import 'screens/splash_screen.dart';
// import 'config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Read API_BASE_URL from --dart-define (used for web builds / different environments)
  ApiConfig.initFromEnvironment();

  runApp(const UndergroundTerminalApp());
}

class UndergroundTerminalApp extends StatefulWidget {
  const UndergroundTerminalApp({super.key});

  @override
  State<UndergroundTerminalApp> createState() => _UndergroundTerminalAppState();
}

class _UndergroundTerminalAppState extends State<UndergroundTerminalApp> {
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Underground Terminal',
      theme: AppTheme.darkTheme,
      home: SplashScreen(cartService: _cartService),
      debugShowCheckedModeBanner: false,
    );
  }
}
