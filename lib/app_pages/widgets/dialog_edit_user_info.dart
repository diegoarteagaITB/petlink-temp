import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petlink_flutter_app/api/ktor/authentication_service.dart';

import 'package:petlink_flutter_app/app_pages/widgets/custom_textfield.dart';
import 'package:petlink_flutter_app/model/additional_info_model.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:text_scroll/text_scroll.dart';

class EditUserInfoWidget extends StatefulWidget {
  final String email;

  const EditUserInfoWidget({Key? key, required this.email}) : super(key: key);

  @override
  _EditUserInfoWidgetState createState() => _EditUserInfoWidgetState();
}

class _EditUserInfoWidgetState extends State<EditUserInfoWidget> {
  late bool fosterValue;
  final List<TextEditingController> textControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  final List<String> fieldTextType = [
    "Age",
    "City",
    "Slogan",
    "Description",
    "Foster"
  ];

  _EditUserInfoWidgetState() {
    fosterValue = false;
  }

  final supabase = Supabase.instance.client;

  File? image;
  Future pickAndUploadImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 25,
      );

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
                Icons.access_alarm_rounded,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Edit User Info",
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
                    "Foster:",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'BalooDa2',
                    ),
                  ),
                  Checkbox(
                    value: fosterValue,
                    onChanged: (value) {
                      setState(() {
                        fosterValue = value!;
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
    late AdditionalUserInfo? additionalUserInfo;
    additionalUserInfo = AdditionalUserInfo(
      idUser: await userAuth.getUserIdByEmail(widget.email),
      age: textControllers[0].text.isNotEmpty ? int.parse(textControllers[0].text) : 0,
      city: textControllers[1].text,
      slogan: textControllers[2].text,
      description: textControllers[3].text,
      foster: fosterValue,
      imgId: await userAuth.getAdditionalUserInfoByUserId(await userAuth.getUserIdByEmail(widget.email)).then((value) => value.imgId)
    );

    var optionalInfo = await AuthService().getAdditionalUserInfoByUserId(additionalUserInfo.idUser);

    // Verificar si el usuario ha subido una imagen
    if (image != null) {
      try {
        final imgId = "${additionalUserInfo.idUser.toString()}_$dateOnPressed";
        await supabase.storage.from('images').upload('pet_images/$imgId', image!);
        additionalUserInfo.imgId = imgId; // Asignamos el valor de imgId después de cargar la imagen correctamente
      } catch (e) {
        print('No se subió ninguna imagen: $e');
      }
    }

    // Realizar la llamada de actualización
    final connection = await AuthService().updateAdditionalUserInfo(
      additionalUserInfo.idUser,
      additionalUserInfo.age != 0 ? additionalUserInfo.age : (optionalInfo?.age ?? 18),
      additionalUserInfo.city.isNotEmpty ? additionalUserInfo.city : (optionalInfo?.city ?? "Uknown city"),
      additionalUserInfo.slogan.isNotEmpty ? additionalUserInfo.slogan : (optionalInfo?.slogan ?? "Slogan not set yet"),
      additionalUserInfo.description.isNotEmpty ? additionalUserInfo.description : (optionalInfo?.description ?? "Uknown description"),
      additionalUserInfo.foster != null ? additionalUserInfo.foster : (optionalInfo?.foster ?? false),
      additionalUserInfo.imgId.isNotEmpty ? additionalUserInfo.imgId : (optionalInfo?.imgId ?? ""),
    );

    if (connection == true) {
      debugPrint("$additionalUserInfo");
      if (additionalUserInfo.imgId.isNotEmpty) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User info updated correctly'),
          ),
        );
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User info updated correctly but not the image'),
          ),
        );
      }
    }
  },
  child: Container(
    width: 100,
    height: 40,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Color.fromARGB(255, 1, 44, 42),
    ),
    padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
    child: const Text(
      'SAVE',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontFamily: 'BalooDa2',
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
)
,

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*
 TextButton(
                    onPressed: () async {
                      final dateOnPressed = DateTime.now();
                      late AdditionalUserInfo? additionalUserInfo;
                      additionalUserInfo = AdditionalUserInfo(
                        idUser: await userAuth.getUserIdByEmail(widget.email),
                        age: textControllers[0].text.isNotEmpty
                            ? int.parse(textControllers[0].text)
                            : 0,
                        city: textControllers[1].text,
                        slogan: textControllers[2].text,
                        description: textControllers[3].text,
                        foster: fosterValue,
                        imgId: "${await userAuth.getUserIdByEmail(widget.email)}_$dateOnPressed",
                      );
                      var optionalInfo = await AuthService()
                          .getAdditionalUserInfoByUserId(
                              additionalUserInfo.idUser);
                      final connection =
                          await AuthService().updateAdditionalUserInfo(
                        additionalUserInfo.idUser,
                        additionalUserInfo.age != 0 ? additionalUserInfo.age : (optionalInfo?.age ?? 18),
                        additionalUserInfo.city.isNotEmpty ? additionalUserInfo.city : (optionalInfo?.city ?? "Uknown city"),
                        additionalUserInfo.slogan.isNotEmpty ? additionalUserInfo.slogan : (optionalInfo?.slogan ?? "Slogan not set yet"),
                        additionalUserInfo.description.isNotEmpty ? additionalUserInfo.description : (optionalInfo?.description ?? "Uknown description"),
                        additionalUserInfo.foster != null ? additionalUserInfo.foster : (optionalInfo?.foster ?? false),
                        additionalUserInfo.imgId.isNotEmpty ? additionalUserInfo.imgId : (optionalInfo?.imgId ?? "11_2023-11-27 16:59:38.095156"),
                      );

                      if (connection == true) {
                        debugPrint("$additionalUserInfo");
                        if (additionalUserInfo.imgId.isNotEmpty) {
                          try {
                            if (additionalUserInfo.imgId.isNotEmpty &&
                                image != null) {
                              await supabase.storage.from('images').upload(
                                    'pet_images/${additionalUserInfo.idUser.toString()}_$dateOnPressed',
                                    image!,
                                  );
                            }
                          } catch (e) {
                            // Manejar la excepción aquí
                            print('No se subio ninguna imagen: $e');
                          }

                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('User info updated correctly'),
                            ),
                          );
                        } else {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'User info updated correctly but not the image'),
                            ),
                          );
                        }
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
                        'SAVE',
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

                  */