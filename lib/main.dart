import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_api_flutter/providers/card_provider.dart';
import 'package:yugioh_api_flutter/screens/card_details.dart';
import 'package:yugioh_api_flutter/screens/random_cards.dart';
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
        '/random_cards': (_) => const RandomCards(),
        '/details': (_) => const CardDetails(),
      },
      initialRoute: '/home',
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
      ],
      child: const MainApp(),
    );
  }
}
