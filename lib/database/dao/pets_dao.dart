import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/model/pets_model.dart';
import 'package:petlink_flutter_app/model/users_model.dart';
import 'package:postgres/postgres.dart';
import 'package:http/http.dart' as http;

class PetsDao {
  final PostgreSQLConnection _database;

  PetsDao(this._database);

  Future<List<Pet>> getPetsByUserId() async {
    final result = await _database.query(
      'SELECT * FROM pets WHERE pet_user_id = @userId',
      substitutionValues: {
        'userId': 1,
      },
    );
    return result.map((row) => Pet.fromMap(row.toColumnMap())).toList();
  }
}
