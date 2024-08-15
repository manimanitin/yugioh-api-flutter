// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';

class NotificationsService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      duration: const Duration(milliseconds: 500),
    );
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
