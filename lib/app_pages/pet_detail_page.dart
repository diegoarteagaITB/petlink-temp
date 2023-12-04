import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:petlink_flutter_app/api/ktor/petRequest_service.dart';

import 'package:petlink_flutter_app/api/supabase/supabase_service.dart';
import 'package:petlink_flutter_app/model/pets_model.dart';
import 'package:petlink_flutter_app/model/users_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetDetailPage extends StatefulWidget {
  const PetDetailPage(
      {super.key,
      required this.pet,
      required this.fullName,
      required this.userId,
      required this.fullUser});

  final int userId;
  final String fullName;
  final Users fullUser;
  final Pet pet;

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  List<String> listOfPetFeaturesName = ["Age", "Gender", "Weight"];
  List<String> listOfPetFeaturesValue = ["9999", "9999", "9999"];

  final supaService = SupabaseService();
  bool buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            alignment: const Alignment(0, -1),
            child: FutureBuilder<Uint8List>(
              future: supaService.getImageBytes(widget.pet.imgId),
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.67,
                    width: MediaQuery.of(context).size.width,
                    child: Image.memory(
                      snapshot.data!,
                      fit: BoxFit.fill,
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.25),
                    child: const CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Container(
            alignment: const Alignment(0, 1),
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 248, 248, 248),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(65),
                  topRight: Radius.circular(65),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1, bottom: 10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (var i = 0; i < 3; i++)
                            Column(
                              children: [
                                Text(
                                  listOfPetFeaturesName[i],
                                  style: const TextStyle(
                                      fontFamily: 'BalooDa2',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  alignment: const Alignment(0, 0),
                                  height: 38,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 248, 248, 248),
                                    borderRadius: BorderRadius.circular(35),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              const Color.fromARGB(255, 0, 0, 0)
                                                  .withOpacity(.09),
                                          offset: const Offset(0, 0),
                                          blurRadius: 8,
                                          spreadRadius: 3),
                                    ],
                                  ),
                                  child: Text(
                                    listOfPetFeaturesValue[i],
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 4, 40, 71),
                                      fontFamily: 'BalooDa2',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      Divider(
                        color: const Color.fromARGB(255, 4, 40, 71),
                        height: 36,
                        indent: MediaQuery.of(context).size.width * 0.1,
                        endIndent: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.1,
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 32,
                              backgroundImage: NetworkImage(
                                  "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(widget.fullUser.name,
                                      style: const TextStyle(
                                          fontFamily: 'BalooDa2',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  const Text(
                                    "Owner",
                                    style: TextStyle(fontFamily: 'BalooDa2'),
                                  ),
                                  Text(
                                    widget.fullUser.email,
                                    style:
                                        const TextStyle(fontFamily: 'BalooDa2'),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.1,
                            right: MediaQuery.of(context).size.width * 0.1,
                            bottom: 20,
                            top: 20),
                        child: const Text(
                          "No sabemos que poner No sabemos que poner No sabemos que poner No sabemos que poner No sabemos que poner No sabemos que poner No sabemos que poner No sabemos que poner No sabemos que poner No sabemos que poner No sabemos que poner No sabemos que poner No sabemos que poner No sabemos que poner No sabemos que poner No sabemos que poner No sabemos que poner No sabemos que poner No sabemos que poner ",
                          style: TextStyle(
                            fontFamily: 'BalooDa2',
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextButton(
                          onPressed: () async {
                            final success = await PetRequest()
                                .sendAdoptionRequest(widget.userId,
                                    widget.pet.petId, widget.fullName);
                            if (success) {
                              debugPrint('Adoption request sent');
                              setState(() {
                                buttonPressed = true;
                              });
                            } else {
                              debugPrint('Failed to send request');
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: const Color.fromARGB(255, 4, 40, 71),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 10),
                            child: const Text(
                              'Adopt',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontFamily: 'BalooDa2',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: const Alignment(0, 0),
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 248, 248, 248),
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(.09),
                    offset: const Offset(0, 0),
                    blurRadius: 15,
                    spreadRadius: 10),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.pet.name,
                    style: const TextStyle(
                        fontFamily: 'BalooDa2',
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.pet.breed,
                    style: const TextStyle(
                      fontFamily: 'BalooDa2',
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    widget.pet.castrated ? "Castrated" : "Not castrated",
                    style: const TextStyle(
                      fontFamily: 'BalooDa2',
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color.fromARGB(119, 0, 0, 0),
                    child: IconButton(
                      color: Colors.black,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
