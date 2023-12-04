import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/global_variables.dart';
import 'package:petlink_flutter_app/main.dart';
import 'package:petlink_flutter_app/model/users_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Funcion que devuelve un booleano si el usuario existe
  Future<bool> userLogin(String email, String password) async {
    final url = Uri.parse('$ipAddress/users/login');

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
  Future<bool> userRegister(Users user) async {
    final url = Uri.parse('$ipAddress/users');

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

  // Funcion que me devuelve el nombre de usuario a traves del email
  Future<String> getNameByEmail(String email) async {
    final response = await http.get(
      Uri.parse('$ipAddress/users/name/$email'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load name of user');
    }
  }

  Future<int> getUserIdByEmail(String email) async {
    final response = await http.get(
      Uri.parse('$ipAddress/users/id/$email'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load name of user');
    }
  }

  // Funcion que devuelve un usuario entero a traves de un id de usuario
  Future<Users> getUserByUserId(int id) async {
    final response = await http.get(
      Uri.parse('$ipAddress/users/fullUser/$id'),
      headers: {"Content-Type": "application/json"},
    );

    debugPrint("aaaaaaaaaaaaaaaaaaaaaaaa " + response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> userMap = json.decode(response.body);

      Users user = Users.fromJson(userMap);

      return user;
    } else {
      throw Exception('Failed to load user');
    }
  }

  

  // Funcion para encriptar la contraseña
  String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}
