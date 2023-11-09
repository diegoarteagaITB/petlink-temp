import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/api/api_variable.dart';
import 'package:petlink_flutter_app/model/users_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String ipAddressAPI = ApiVariable().ipAddress;

  // Funcion que devuelve un booleano si el usuario existe
  Future<bool> userLogin(String email, String password) async {
    final url = Uri.parse('$ipAddressAPI/users/login');

    var encrpytedPassword = encryptPassword(password);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': encrpytedPassword,
        }),
      );
      debugPrint("${response.statusCode} AAAA");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      return false;
    }
  }

  // Funcion que devuelve un booleano si el usuario se ha registrado correctamente
  Future<bool> userRegister(User user) async {
    final url = Uri.parse('$ipAddressAPI/users');

    debugPrint("Password decrypt: ${user.password}");

    var encrpytedPassword = encryptPassword(user.password);

    debugPrint("Password encrypt: $encrpytedPassword");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': user.id,
          'name': user.name,
          'dni': user.dni,
          'phone': user.phone,
          'email': user.email,
          'password': encrpytedPassword,
          'imgProfile': user.profileImg,
        }),
      );
      debugPrint("${response.statusCode} AAAA");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      return false;
    }
  }

  // Funcion para encriptar la contraseña
  String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}
