import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_api_flutter/providers/card_provider.dart';
import 'package:yugioh_api_flutter/screens/card_details_screen.dart';
import 'package:yugioh_api_flutter/screens/random_cards.dart';
import 'package:yugioh_api_flutter/services/auth_service.dart';
import 'package:yugioh_api_flutter/services/notification_service.dart';
import 'screens/screens.dart';

void main() {
  runApp(const AppState());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "yu-gi-oh",
      routes: {
        '/home': (_) => const HomeScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/random_cards': (_) => const RandomCards(),
        '/details': (_) => const CardDetails(),
      },
      initialRoute: '/home',
      scaffoldMessengerKey: NotificationsService.messengerKey,
    );
  }
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CardProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const MainApp(),
    );
  }
}
