import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/api/ktor/pet_service.dart';
import 'package:petlink_flutter_app/app_pages/widgets/search_view_filter.dart';
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
  late Future<List<String>> adoptionRequestsFuture;
  
  @override
  void initState() {
    super.initState();
    print("UserId --->>>>>> ${widget.userId}");
    petsFuture = PetService().getPetsByUserId(widget.userId);
  }

  void updateRequestList(int petId){
    setState(() {
      adoptionRequestsFuture = PetService().getAdoptionRequestsForPet(petId);
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
            showAdoptionRequestsDialog(context, pet.petId, widget.userId, updateRequestList);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              child: ListTile(
                leading: CircleAvatar(
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
  Future<void> showAdoptionRequestsDialog(BuildContext context, int petId, int userId, Function updateRequestList) async {
    try{
      final List <String> adoptionRequests = await PetService().getAdoptionRequestsForPet(petId);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Adoption Requests'),
            content: Column(
              children: [
                for (String username in adoptionRequests)
                ListTile(
                  title: Text(username),
                  trailing: IconButton(
                    onPressed: () async{
                      int? requestId = await PetService().getAdoptionRequestId(petId, username);
                      if (requestId != null){
                        bool deleted = await PetService().deleteAdoptionRequest(requestId);
                        if(deleted){
                          RequestsPageState? requestsPageState = context.findAncestorStateOfType<RequestsPageState>();
                          if (requestsPageState != null) {
                            requestsPageState.updateRequestList(petId);
                          } else{
                            print('Failed to find RequestsPageState');
                          }
                        } else{
                          print('Failed to delete adoption request');
                        }
                      } else{
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
    );
  } catch(e){
    print("Error cargar solicitudes de adopcion: $e");
  }
  }
}

  