import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petlink_flutter_app/global_variables.dart';
import 'package:petlink_flutter_app/main.dart';

class PetRequest {
  Future<bool> sendAdoptionRequest(int petId) async {
    final url = Uri.parse('$ipAddress/adoptionrequests');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'requestingUserId': loggedUserId,
          'petId': petId,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en la solicitud de adopción: $e');
      return false;
    }
  }

  // Obtiene la lista de usuarios que han solicitado la adopción de una mascota específica.
  Future<List<String>> getAdoptionRequestsForPet(int petId) async {
    final response = await http.get(
      Uri.parse('$ipAddress/pets/adoptionrequests/$petId'),
      headers: {"Content-Type": "application/json"},
    );

    print(response.body);

    if (response.statusCode == 200) {
      final List<String> body = List<String>.from(json.decode(response.body));
      return body;
    } else {
      throw Exception('Failed to load adoption requests');
    }
  }

  Future<int?> getAdoptionRequestId(int petId, String username) async {
    final response = await http.get(
      Uri.parse('$ipAddress/adoptionrequests/$petId/$username'),
      headers: {"Content-Type": "application/json"},
    );

    print(response.body);
    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        // Asegúrate de que 'id' sea el nombre correcto del campo en tu base de datos
        return int.tryParse(body['requestId'].toString());
      } else {
        throw Exception('Failed to get adoption request id');
      }
    } catch (e) {
      print('Error in getadoptiooon : $e');
      throw Exception('Failed to get adoption request id');
    }
  }

  Future<bool> deleteAdoptionRequest(int requestedUserId, int petId) async {
    final url =
        Uri.parse('$ipAddress/adoptionrequests/$requestedUserId/$petId');
    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en la eliminación de la solicitud de adopción: $e');
      print('Delete URL: $url');
      return false;
    }
  }

  Future<bool> existAdoptionRequest(int petId, int requestingUserId) async {
    final url =
        Uri.parse('$ipAddress/adoptionrequests/exist/$petId/$requestingUserId');

    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return response.body.toLowerCase() == "true";
    } else {
      return false;
    }
  }
}
