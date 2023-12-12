import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_api_flutter/screens/screens.dart';
import 'package:yugioh_api_flutter/services/auth_service.dart';

import 'package:yugioh_api_flutter/services/services.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({super.key});

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
            } else {
              return const ProfileScreen();
            }
          },
        ),
      ),
    );
  }
}
