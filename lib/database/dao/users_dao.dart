import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class UserDao {
  // Database declaration
  final PostgreSQLConnection _database;

  UserDao(this._database);

  // User checks
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 8;
  }

  bool isValidCredentials(String username, String password) {
    if (username.isEmpty || password.isEmpty) {
      return false;
    }
    return true;
  }

  bool userNotExists(String email, String password) {
    if (loginUser(email, password) == true) {
      return false;
    } else {
      return true;
    }
  }

  // Function to sign up
  Future<bool> registerUser(String email, String password) async {
    try {
      final result = await _database.query(
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

  // Function to
  Future<bool> loginUser(String email, String password) async {
    try {
      final results = await _database.query(
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
