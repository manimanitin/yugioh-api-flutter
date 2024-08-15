import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yugioh_api_flutter/providers/deck_provider.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'loginbackend.somee.com';
  //final String _firebaseToken = 'AIzaSyCD36g1c5N9WPp4PCmVwt2jEzdWIGtglso';

  final storage = const FlutterSecureStorage();

  // Si retornamos algo, es un error, si no, todo bien!
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      //'returnSecureToken': true
    };

    final url = Uri.http(_baseUrl, '/api/Cuentas/registrar');

    final resp = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(authData));

    if ((resp.statusCode ~/ 100) == 2) {
      final Map<String, dynamic> decodedResp = json.decode(resp.body);

      // Token hay que guardarlo en un lugar seguro
      await storage.write(key: 'userId', value: authData["email"]);
      await storage.write(key: 'token', value: decodedResp['token']);
      // decodedResp['idToken'];
      return null;
    } else {
      final Map<String, dynamic> decodedResp = json.decode(resp.body)[0];
      return decodedResp['description'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };
    final url = Uri.http(_baseUrl, '/api/Cuentas/Login');

    //final url2 = Uri.https(_baseUrl, '/Prueba/on');

    /*final resp2 = await http.get(url2, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    });*/

    final resp = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(authData));

    /*final resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: json.encode(authData));*/

    if ((resp.statusCode ~/ 100) == 2) {
      final Map<String, dynamic> decodedResp = json.decode(resp.body);

      // Token hay que guardarlo en un lugar seguro
      await storage.write(key: 'userId', value: authData["email"]);

      await storage.write(key: 'token', value: decodedResp['token']);
      // decodedResp['idToken'];
      return null;
    } else {
      final String error = resp.body;

      return error;
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'userId');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  readUserId() {
    return storage.read(key: 'userId');
  }
}
