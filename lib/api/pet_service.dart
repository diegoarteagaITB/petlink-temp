import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petlink_flutter_app/api/api_variable.dart';
import 'package:petlink_flutter_app/model/pets_model.dart';

class PetService {
  final String ipAddressAPI = ApiVariable().ipAddress;

  // Obtiene una lista de todas las mascotas disponibles desde la API.
  Future<List<Pet>> getAllPets() async {
    final response = await http.get(
      Uri.parse('$ipAddressAPI/pets/'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List body = json.decode(response.body);
      return body.map((e) => Pet.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load pets');
    }
  }

  // Obtiene una lista de mascotas disponibles para adopción desde la API.
  Future<List<Pet>> getPetsInAdoption() async {
    final response = await http.get(
      Uri.parse('$ipAddressAPI/pets/inadoption'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List body = json.decode(response.body);
      return body.map((e) => Pet.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load pets');
    }
  }

  // Obtiene una lista de mascotas asociadas a un usuario específico desde la API.
  Future<List<Pet>> getPetsByUserId(int userId) async {
    final response = await http.get(
      Uri.parse('$ipAddressAPI/pets/$userId'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List body = json.decode(response.body);
      return body.map((e) => Pet.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load pets');
    }
  }

  // Funcion que crea una mascota
  Future<bool> postPet(Pet pet) async {
    final url = Uri.parse('$ipAddressAPI/pets');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': pet.petId,
          'userId': pet.userId,
          'inAdoption': pet.inAdoption,
          'name': pet.name,
          'type': pet.type,
          'gender': pet.gender,
          'breed': pet.breed,
          'castrated': pet.castrated,
          'medHistId': pet.medHistId,
          'imgId': pet.imgId,
        }),
      );
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
}
