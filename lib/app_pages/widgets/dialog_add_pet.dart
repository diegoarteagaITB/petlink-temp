import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/api/authentication_service.dart';
import 'package:petlink_flutter_app/api/pet_service.dart';
import 'package:petlink_flutter_app/app_pages/widgets/custom_textfield.dart';
import 'package:petlink_flutter_app/model/pets_model.dart';

import 'package:flutter/material.dart';

class AddPetWidget extends StatefulWidget {
  final String email;

  const AddPetWidget({Key? key, required this.email}) : super(key: key);

  @override
  _AddPetWidgetState createState() => _AddPetWidgetState();
}

class _AddPetWidgetState extends State<AddPetWidget> {
  late bool castratedValue;
  late bool adoptionValue;
  final List<TextEditingController> textControllers = List.generate(
    5,
    (index) => TextEditingController(),
  );

  final List<String> fieldTextType = [
    "Name",
    "Pet Type",
    "Gender",
    "Breed",
    "Castrated",
  ];

  _AddPetWidgetState() {
    castratedValue = false;
    adoptionValue = false;
  }

  @override
  Widget build(BuildContext context) {
    final userAuth = AuthService();

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 3, 25, 44),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Icon(
                Icons.pets_rounded,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "ADD NEW PET",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BalooDa2',
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Icon(
                Icons.pets_rounded,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      content: Container(
        height: 500,
        width: 330,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              for (var i = 0; i < 4; i++)
                customTextFormField(
                  context: context,
                  controller: textControllers[i],
                  labelText: fieldTextType[i],
                  keyboardType: TextInputType.text,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                ),
              Row(
                children: [
                  const Text(
                    "Castrated:",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'BalooDa2',
                    ),
                  ),
                  Checkbox(
                    value: castratedValue,
                    onChanged: (value) {
                      setState(() {
                        castratedValue = value!;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "Adoption: ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'BalooDa2',
                    ),
                  ),
                  Checkbox(
                    value: adoptionValue,
                    onChanged: (value) {
                      setState(() {
                        adoptionValue = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromARGB(255, 44, 1, 1),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 9, horizontal: 10),
                      child: const Text(
                        'CANCEL',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: 'BalooDa2',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      late Pet? pet;
                      pet = Pet(
                        petId: 0,
                        userId: await userAuth.getUserIdByEmail(widget.email),
                        inAdoption: adoptionValue,
                        name: textControllers[0].text,
                        type: textControllers[1].text,
                        gender: textControllers[2].text,
                        breed: textControllers[3].text,
                        castrated: castratedValue,
                        medHistId: "",
                        imgId:
                            "https://images.fineartamerica.com/images-medium-large/dog-black-and-white-portrait-sumit-mehndiratta.jpg",
                      );
                      final connection = await PetService().postPet(pet);
                      debugPrint(connection.toString());
                      if (connection == true) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pet added correctly'),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromARGB(255, 1, 44, 42),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 9, horizontal: 10),
                      child: const Text(
                        'ADD PET',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: 'BalooDa2',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
