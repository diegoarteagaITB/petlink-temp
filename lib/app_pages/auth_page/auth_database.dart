import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class AuthService {
  final PostgreSQLConnection _connection;

  AuthService(this._connection);

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 8;
  }

  bool isValidCredentials(String username, String password) {
    if (username.isEmpty || password.isEmpty) {
      return false; // Los campos no deben estar vacíos.
    }

    return true;
  }

  Future<bool> registerUser(String email, String password) async {
    try {
      final result = await _connection.query(
        'INSERT INTO users (email, password) VALUES (@email, @password)',
        substitutionValues: {
          'email': email,
          'password': password,
        },
      );
      return result.affectedRowCount > 0;
    } catch (e) {
      debugPrint("Error en el registro: $e");
      return false;
    }
  }

  Future<bool> authenticateUser(String email, String password) async {
    try {
      final results = await _connection.query(
        'SELECT * FROM users WHERE email = @email AND @password = @password',
        substitutionValues: {
          'email': email,
          'password': password,
        },
      );

      if (results.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } finally {}
  }
}
