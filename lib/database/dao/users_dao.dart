import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/model/users_model.dart';
import 'package:postgres/postgres.dart';
import 'package:dni_nie_validator/dni_nie_validator.dart';

class UserDao {
  // Database declaration
  final PostgreSQLConnection _database;
  final User _user;

  UserDao(this._database, this._user);

  // User checks
  bool isValidEmail() {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(_user.email);
  }

  bool isValidPassword() {
    return _user.password.length >= 6;
  }

  bool isValidCredentials() {
    if (_user.password.isEmpty || _user.email.isEmpty) {
      return false;
    }
    return true;
  }

  bool userNotExists() {
    if (loginUser() == true) {
      return false;
    } else {
      return true;
    }
  }

  bool validateDni() {
    if (_user.dni.isValidDNI()) {
      return true;
    } else {
      return false;
    }
  }

  bool validPhone() {
    if (_user.phone.length == 9) {
      return true;
    } else {
      return false;
    }
  }

  Future<String?> getUserFullName() async {
    try {
      final result = await _database.query(
        'SELECT CONCAT(first_name, \' \', last_name) FROM users WHERE email = @email AND password = @password',
        substitutionValues: {
          'email': _user.email,
          'password': _user.password,
        },
      );
      if (result.isNotEmpty) {
        final firstName = result[0][0];

        debugPrint("AAAAAAAAAAAAAAAAAAAA $firstName");
        return "$firstName";
      }
    } catch (e) {
      debugPrint("Error en el registro: $e");
    }
    return null;
  }

/*
  Future<bool> registerUser() async {
    try {
      final result = await _database.query(
        'INSERT INTO users (first_name, dni, email, password, phone, img_profile, last_name) VALUES (@first_name, @dni, @email, @password, @phone, @img_profile, @last_name)',
        substitutionValues: {
          'first_name': _user.firstName,
          'dni': _user.dni,
          'email': _user.email,
          'password': _user.password,
          'phone': _user.phone,
          'img_profile': "placeholder.png",
          'last_name': _user.lastName,
        },
      );
      return result.affectedRowCount > 0;
    } catch (e) {
      debugPrint("Error en el registro: $e");
      return false;
    }
  }*/

  Future<bool> loginUser() async {
    try {
      final results = await _database.query(
        'SELECT * FROM users WHERE email = @email AND password = @password',
        substitutionValues: {
          'email': _user.email,
          'password': _user.password,
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
