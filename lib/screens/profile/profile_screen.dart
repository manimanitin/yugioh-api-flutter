// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:yugioh_api_flutter/colors/colors.dart';
import 'package:yugioh_api_flutter/providers/deck_provider.dart';
import 'package:yugioh_api_flutter/screens/decks_screen.dart';
import 'package:yugioh_api_flutter/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_api_flutter/services/notification_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final deckProvider = Provider.of<DeckProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deck List'),
        backgroundColor: AppColors.secondaryColor,
        leading: IconButton(
          icon: const Icon(Icons.login_outlined),
          onPressed: () {
            deckProvider.clearDecks();
            authService.logout();
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: DeckScreen(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton(
            onPressed: () async {
              String message = await deckProvider.saveDecks();
              NotificationsService.showSnackbar(message);
            },
            icono: Icons.save,
            color: AppColors.buttonGreenColor,
          ),
          const SizedBox(height: 10),
          CustomButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Warning'),
                content:
                    const Text('This will delete your Deck and Extra Deck'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      deckProvider.deleteDecks();
                      Navigator.pop(context, 'Delete');
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
            icono: Icons.delete_forever,
            color: AppColors.accentColor,
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icono;
  final VoidCallback? onPressed;
  final Color color;
  const CustomButton(
      {super.key, required this.icono, this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: onPressed,
      backgroundColor: color,
      child: Icon(icono),
    );
  }
}
