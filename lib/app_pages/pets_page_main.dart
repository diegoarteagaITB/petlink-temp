import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/api/pet_service.dart';
import 'package:petlink_flutter_app/app_pages/widgets/search_view_filter.dart';
import 'package:petlink_flutter_app/model/pets_model.dart';
import 'package:http/http.dart' as http;

class PetsPage extends StatefulWidget {
  const PetsPage({super.key});

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  late Future<List<Pet>> petsFuture;

  @override
  void initState() {
    super.initState();
    petsFuture = PetService().getPetsInAdoption();
  }
  // Color.fromARGB(255, 4, 40, 71)

  double opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 4, 40, 71),
        toolbarHeight: 80,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: SearchViewFilterPets(petList: petsFuture),
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
                        image: DecorationImage(
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
                        image: DecorationImage(
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
                        image: DecorationImage(
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
                        image: DecorationImage(
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
                        image: DecorationImage(
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
            child: Center(
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
          )
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
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 4, 40, 71),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          pet.imgId,
                          width: 120,
                        )
                        /*
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ),
                        ),
                        imageUrl: pet.imgId,
                        width: 120,
                      ),*/
                        ),
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
                          onPressed: () => {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white,
                            ),
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
          );
        },
      ),
    );
  }
}
