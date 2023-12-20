import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/api/ktor/petRequest_service.dart';
import 'package:petlink_flutter_app/api/ktor/pet_service.dart';
import 'package:petlink_flutter_app/app_pages/widgets/search_view_filter.dart';
import 'package:petlink_flutter_app/model/adoption_request_model.dart';
import 'package:petlink_flutter_app/model/pets_model.dart';
import 'package:http/http.dart' as http;

class RequestsPage extends StatefulWidget {
  final int userId;
  const RequestsPage({Key? key, required this.userId}) : super(key: key);

  @override
  RequestsPageState createState() => RequestsPageState();
}

class RequestsPageState extends State<RequestsPage> {
  late Future<List<Pet>> petsFuture;
  late Future<List<AdoptionRequests>> adoptionRequestsFuture;

  @override
  void initState() {
    super.initState();
    print("UserId --->>>>>> ${widget.userId}");
    petsFuture = PetService().getPetsByUserId(widget.userId);
  }

  void updateRequestList(int petId) {
    setState(() {
      adoptionRequestsFuture = PetRequest().getAdoptionRequestsForPet(petId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Requests'),
      ),
      body: FutureBuilder<List<Pet>>(
        future: petsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final pets = snapshot.data!;
            return buildPets(pets);
          } else {
            return Center(child: Text('No pets available'));
          }
        },
      ),
    );
  }

  Widget buildPets(List<Pet> pets) {
    return ListView.builder(
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        return GestureDetector(
          onTap: () {
            showAdoptionRequestsDialog(
                context, pet.petId, widget.userId, updateRequestList);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.pets, color: Colors.white),
                ),
                title: Text(pet.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pet.breed),
                    Text(pet.castrated ? 'Castrated' : 'Not castrated'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Muestra un diálogo con la lista de usuarios que han solicitado la adopción de la mascota.
  Future<void> showAdoptionRequestsDialog(
  BuildContext context, 
  int petId,
  int userId, 
  Function updateRequestList
) async {
  try {
    final List<AdoptionRequests> adoptionRequests =
        await PetRequest().getAdoptionRequestsForPet(petId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adoption Requests'),
          content: Column(
            children: [
              for (var request in adoptionRequests)
                ListTile(
                  title: Text('User ID: ${request.requesting_user_id}'),
                  subtitle: Text('Request ID: ${request.request_id}'),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      final success = await PetService().updateOwnerPet(petId, request.requesting_user_id);
                      if (success) {
                        updateRequestList(petId);
                        Navigator.pop(context); // Cerrar el diálogo después de la confirmación
                      } else {
                        // Manejar error si la actualización falla
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update owner'),
                          ),
                        );
                      }
                    },
                    child: Text('Confirm Adoption'),
                  ),
                ),
            ],
          ),
        );
      },
    );

  } catch (e) {
    print("Error cargar solicitudes de adopcion: $e");
  }
}
}



/*showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Adoption Requests'),
            content: Column(
              children: [
                for (AdoptionRequests username in adoptionRequests)
                  ListTile(
                    title: Text(username),
                    trailing: IconButton(
                      onPressed: () async {
                        int? requestId = await PetRequest()
                            .getAdoptionRequestId(petId, username);
                        if (requestId != null) {
                          bool deleted = await PetRequest()
                              .deleteAdoptionRequest(userId, petId);
                          if (deleted) {
                            RequestsPageState? requestsPageState = context
                                .findAncestorStateOfType<RequestsPageState>();
                            if (requestsPageState != null) {
                              requestsPageState.updateRequestList(petId);
                            } else {
                              print('Failed to find RequestsPageState');
                            }
                          } else {
                            print('Failed to delete adoption request');
                          }
                        } else {
                          print('Failed to get adoption request id');
                        }
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );*/