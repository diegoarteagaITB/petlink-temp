import 'dart:core';

import 'dart:typed_data';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/api/ktor/pet_service.dart';
import 'package:petlink_flutter_app/api/supabase/supabase_service.dart';
import 'package:petlink_flutter_app/app_pages/pet_detail_page.dart';
import 'package:petlink_flutter_app/app_pages/widgets/search_view_filter.dart';
import 'package:petlink_flutter_app/model/pets_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetsPage extends StatefulWidget {
  final int userId;
  final String fullName;
 
  const PetsPage({super.key, required this.userId, required this.fullName});

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  late Future<List<Pet>> petsFuture;
  bool buttonPressed = false;

  @override
  void initState() {
    super.initState();
    petsFuture = PetService().getPetsInAdoption();
  }
  // Color.fromARGB(255, 4, 40, 71)

  double opacity = 1.0;
  final supabase = Supabase.instance.client;
  final supaService = SupabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 40, 71),
        toolbarHeight: 80,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: SearchViewFilterPets(
          onSearchTextChanged: (text) {
            setState(() {
              petsFuture = text.isNotEmpty
                  ? PetService().getPetsByBreed(text)
                  : PetService().getPetsInAdoption();
            });
          },
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 4, 40, 71),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {},
                    child: Ink(
                      width: 85,
                      height: 100,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage('assets/images/dog_widget.png'),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue.withOpacity(opacity),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {},
                    child: Ink(
                      width: 85,
                      height: 100,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage('assets/images/cat_widget.png'),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue.withOpacity(opacity),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {},
                    child: Ink(
                      width: 85,
                      height: 100,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage('assets/images/bird_widget.png'),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue.withOpacity(opacity),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {},
                    child: Ink(
                      width: 85,
                      height: 100,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            image:
                                AssetImage('assets/images/felidae_widget.png'),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue.withOpacity(opacity),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {},
                    child: Ink(
                      width: 85,
                      height: 100,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage('assets/images/fish_widget.png'),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue.withOpacity(opacity),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Pet>>(
              future: petsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Color.fromARGB(255, 4, 40, 71),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Loading data...",
                        style: TextStyle(
                            fontFamily: 'BalooDa2', color: Colors.white),
                      ),
                    ],
                  );
                } else if (snapshot.hasData) {
                  final pets = snapshot.data!;
                  return buildPets(pets);
                } else {
                  return const Text("No data available");
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPets(List<Pet> pets) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: pets.length,
        itemBuilder: (BuildContext context, int index) {
          final pet = pets[index];

          return Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PetDetailPage(pet: pet),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 4, 40, 71),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 140,
                      height: 100,
                      child: buildPetImages(pet),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            pet.name,
                            style: const TextStyle(
                              fontFamily: 'BalooDa2',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 19,
                            ),
                          ),
                          Text(
                            pet.breed,
                            style: const TextStyle(
                              fontFamily: 'BalooDa2',
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            pet.castrated ? "Castrated" : "Not castrated",
                            style: const TextStyle(
                              fontFamily: 'BalooDa2',
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                    if (pet.inAdoption)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SizedBox(
                          width: 70,
                          height: 30,
                          child: TextButton(
                            onPressed: () async {
                              final success = await PetService()
                                  .sendAdoptionRequest(widget.userId, pet.petId, widget.fullName);
                              if (success) {
                                print('Adoption request sent');
                                setState(() {
                                  buttonPressed = true;
                                });
                              } else {
                                print('Failed to send request');
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateColor.resolveWith((states) {
                                if (buttonPressed) {
                                  return Colors.transparent;
                                } else {
                                  return Colors.white;
                                }
                              }),
                            ),
                            child: const Text(
                              "Adopt",
                              style: TextStyle(
                                fontFamily: 'BalooDa2',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildPetImages(Pet pet) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FutureBuilder<Uint8List>(
          future: supaService.getImageBytes(pet.imgId),
          builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SizedBox(
                width: 120,
                height: 80,
                child: CachedMemoryImage(
                  uniqueKey: pet.imgId,
                  bytes: snapshot.data,
                  fit: BoxFit.fill,
                ),
              );
            } else {
              return const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
