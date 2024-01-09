import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/api/ktor/pet_service.dart';
import 'package:petlink_flutter_app/app_pages/widgets/build_pet_image.dart';
import 'package:petlink_flutter_app/global_variables.dart';
import 'package:petlink_flutter_app/model/pets_model.dart';
import 'package:text_scroll/text_scroll.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({Key? key}) : super(key: key);

  @override
  RequestsPageState createState() => RequestsPageState();
}

class AdoptionRequest {
  int requestId;
  int petId;
  String requesterName;

  AdoptionRequest({
    required this.requestId,
    required this.petId,
    required this.requesterName,
  });
}

class RequestsPageState extends State<RequestsPage> {
  late Future<List<Pet>> userPetList;
  int? selectedPetId;

  @override
  void initState() {
    super.initState();
    userPetList = PetService().getPetsByUserId(loggedUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pet Adoption Request'),
        ),
        body: FutureBuilder<List<Pet>>(
          future: userPetList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final pets = snapshot.data!;
              return buildPetsAndRequestByPet(pets);
            } else {
              return const Center(child: Text('No pets available'));
            }
          },
        ));
  }

  List<AdoptionRequest> adoptionRequests = [
    AdoptionRequest(requestId: 1, petId: 41, requesterName: 'User1'),
    AdoptionRequest(requestId: 2, petId: 41, requesterName: 'User2'),
    AdoptionRequest(requestId: 3, petId: 41, requesterName: 'User3'),
  ];

  Widget buildPetsAndRequestByPet(List<Pet> pets) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        Pet pet = pets[index];
        bool isSelected = selectedPetId == pet.petId;
        List<AdoptionRequest> petAdoptionRequests = adoptionRequests
            .where((request) => request.petId == pet.petId)
            .toList();

        return Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  selectedPetId = pet.petId;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: selectedPetId == pet.petId
                        ? const Color.fromARGB(255, 6, 55, 99)
                        : const Color.fromARGB(255, 4, 40, 71),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: const TextStyle(
                            fontFamily: 'BalooDa2',
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      TextScroll(
                        'Toca para ver las solicitudes de esta mascota          ',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                        mode: TextScrollMode.endless,
                        pauseBetween: const Duration(milliseconds: 500),
                        velocity:
                            const Velocity(pixelsPerSecond: Offset(20, 0)),
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (isSelected)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (AdoptionRequest request in petAdoptionRequests)
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.90,
                          height: 40,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: selectedPetId == pet.petId
                                ? const Color.fromARGB(255, 6, 55, 99)
                                : const Color.fromARGB(255, 4, 40, 71),
                          ),
                          child: Center(
                            child: Text(
                              request.requesterName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'BalooDa2',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (petAdoptionRequests.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.90,
                          height: 40,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: selectedPetId == pet.petId
                                ? const Color.fromARGB(255, 6, 55, 99)
                                : const Color.fromARGB(255, 4, 40, 71),
                          ),
                          child: const Center(
                            child: Text(
                              'Todavía no hay solicitudes',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'BalooDa2',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}
