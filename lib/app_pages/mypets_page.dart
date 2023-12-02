import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/api/ktor/pet_service.dart';

import 'package:petlink_flutter_app/app_pages/widgets/search_view_filter.dart';
import 'package:petlink_flutter_app/model/pets_model.dart';
import 'package:http/http.dart' as http;

class MyPetsPage extends StatefulWidget {
  final int userId;
  const MyPetsPage({Key? key, required this.userId}) : super(key: key);

  @override
  _MyPetsPageState createState() => _MyPetsPageState();
}

class _MyPetsPageState extends State<MyPetsPage> {
  late Future<List<Pet>> petsFuture;

  @override
  void initState() {
    super.initState();
    print("UserId --->>>>>> ${widget.userId}");
    petsFuture = PetService().getPetsByUserId(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Pets'),
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
    print('Numbeeerrr of peeets ------->>>>>>>> ${pets.length}');
    return ListView.builder(
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 5,
            child: ListTile(
              leading: CircleAvatar(
                // Puedes usar una imagen en lugar de un color
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
              trailing: pet.inAdoption
                  ? ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                      child: Text('Adopt'),
                    )
                  : SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}
