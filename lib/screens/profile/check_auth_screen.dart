import 'package:flutter/material.dart';
import 'package:yugioh_api_flutter/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_api_flutter/screens/profile/login_screen.dart';
import 'package:yugioh_api_flutter/screens/screens.dart';
import 'package:yugioh_api_flutter/services/auth_service.dart';

import 'package:yugioh_api_flutter/services/services.dart';

class CheckAuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) return const Text('');

            if (snapshot.data == '') {
              return const LoginScreen();
              /*
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const LoginScreen(),
                        transitionDuration: const Duration(seconds: 0)));
              });*/
            } else {
              return const ProfileScreen();
              /*
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const ProfileScreen(),
                        transitionDuration: const Duration(seconds: 0)));
              });
              */
            }

            return Container();
          },
        ),
      ),
    );
  }
}
