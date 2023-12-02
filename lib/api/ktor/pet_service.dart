import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petlink_flutter_app/main.dart';
import 'package:petlink_flutter_app/model/pets_model.dart';

class PetService {
  // Obtiene una lista de todas las mascotas disponibles desde la API.
  Future<List<Pet>> getAllPets() async {
    final response = await http.get(
      Uri.parse('$ipAddress/pets/'),
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
      Uri.parse('$ipAddress/pets/inadoption'),
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
      Uri.parse('$ipAddress/pets/$userId'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List body = json.decode(response.body);
      return body.map((e) => Pet.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load pets');
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

  // Función para buscar animales por su raza
  Future<List<Pet>> getPetsByBreed(String breed) async {
    final response = await http.get(
      Uri.parse(
          '$ipAddress/pets/bybreed/${breed.toLowerCase()}'), // Reemplaza con la URL correcta
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List body = json.decode(response.body);
      return body.map((e) => Pet.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load pets');
    }
  }

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

// Funcion que crea una mascota
  Future<bool> postPet(Pet pet) async {
    final url = Uri.parse('$ipAddress/pets');

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
