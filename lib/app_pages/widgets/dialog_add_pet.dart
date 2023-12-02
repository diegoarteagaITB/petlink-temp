import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petlink_flutter_app/api/ktor/authentication_service.dart';
import 'package:petlink_flutter_app/api/ktor/pet_service.dart';
import 'package:petlink_flutter_app/api/supabase/supabase_service.dart';
import 'package:petlink_flutter_app/app_pages/widgets/custom_textfield.dart';
import 'package:petlink_flutter_app/main.dart';
import 'package:petlink_flutter_app/model/pets_model.dart';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:text_scroll/text_scroll.dart';

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
    4,
    (index) => TextEditingController(),
  );

  final List<String> fieldTextType = [
    "Name",
    "Pet Type",
    "Breed",
    "Castrated",
  ];

  _AddPetWidgetState() {
    castratedValue = false;
    adoptionValue = false;
  }

  final supabase = Supabase.instance.client;

  File? image;
  Future pickAndUploadImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
        debugPrint(imageTemp.toString());
        debugPrint(image.toString());
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
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
        height: 510,
        width: 330,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              for (var i = 0; i < 3; i++)
                customTextFormField(
                  context: context,
                  controller: textControllers[i],
                  labelText: fieldTextType[i],
                  keyboardType: TextInputType.text,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InputChip(label: Text("Male")),
                    InputChip(label: Text("Female"))
                  ],
                ),
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
              const Text(
                "Pet image: ",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BalooDa2',
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        pickAndUploadImage(ImageSource.gallery);
                      },
                      child: Container(
                        width: 110,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color.fromARGB(255, 3, 25, 44),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 11, horizontal: 10),
                        child: const TextScroll(
                          'Pick Image from Galery          ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontFamily: 'BalooDa2',
                            fontWeight: FontWeight.bold,
                          ),
                          mode: TextScrollMode.endless,
                          pauseBetween: Duration(milliseconds: 500),
                          velocity: Velocity(pixelsPerSecond: Offset(20, 0)),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        pickAndUploadImage(ImageSource.camera);
                      },
                      child: Container(
                        width: 110,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color.fromARGB(255, 3, 25, 44),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 11, horizontal: 10),
                        child: const TextScroll(
                          'Pick Image from Camera          ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontFamily: 'BalooDa2',
                            fontWeight: FontWeight.bold,
                          ),
                          mode: TextScrollMode.endless,
                          pauseBetween: Duration(milliseconds: 500),
                          velocity: Velocity(pixelsPerSecond: Offset(20, 0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                  width: 110,
                  height: 140,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: image != null
                            ? FileImage(image!)
                            : const AssetImage(
                                    "assets/images/images_preview.png")
                                as ImageProvider<Object>,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color.fromARGB(255, 3, 25, 44))),
                ),
              ),
              const Text(
                "Recommended size: 1280p x 720p",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BalooDa2',
                ),
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
                      final dateOnPressed = DateTime.now();

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
                            "${await userAuth.getUserIdByEmail(widget.email)}_$dateOnPressed",
                      );
                      final connection = await PetService().postPet(pet);

                      if (connection == true) {
                        await supabase.storage.from('images').upload(
                            'pet_images/${pet.userId.toString()}_$dateOnPressed',
                            image!);

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
