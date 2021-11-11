import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:productosapp/secure_storage.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseKey = 'AIzaSyDSjJoB7bMQBRKxILt_doLCxzH3uTXMh3k';

  static const storage = FlutterSecureStorage();

  // * Si la función retorna null quiere decir que todo funcionó perfectamente
  // * Si la función retorna el String quiere decir que ocurrió un error y se mostrará el mensaje del error
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseKey,
    });

    final res = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedData = json.decode(res.body);

    if (decodedData.containsKey('idToken')) {
      await SecureStorage.writeIdToken(decodedData['idToken']);

      return null;
    }

    return decodedData['error']['message'];
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseKey,
    });

    final res = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedData = json.decode(res.body);

    if (decodedData.containsKey('idToken')) {
      await SecureStorage.writeIdToken(decodedData['idToken']);

      return null;
    }

    return decodedData['error']['message'];
  }

  Future logout() async {
    await storage.delete(key: 'idToken');
  }

  Future<String> readIdToken() async {
    return await storage.read(key: 'idToken') ?? '';
  }
}
