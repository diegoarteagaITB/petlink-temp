import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petlink_flutter_app/global_variables.dart';
import 'package:petlink_flutter_app/main.dart';

class PetRequest {
  Future<bool> sendAdoptionRequest(
      int userId, int petId, String fullName) async {
    final url = Uri.parse('$ipAddress/pets/adoptionrequests');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'petId': petId,
          'fullname': fullName,
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
}
