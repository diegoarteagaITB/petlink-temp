import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/api/ktor/authentication_service.dart';
import 'package:petlink_flutter_app/api/ktor/pet_service.dart';
import 'package:petlink_flutter_app/api/supabase/supabase_service.dart';
import 'package:petlink_flutter_app/app_pages/widgets/dialog_edit_user_info.dart';
import 'package:petlink_flutter_app/global_variables.dart';
import 'package:petlink_flutter_app/model/additional_info_model.dart';
import 'package:petlink_flutter_app/model/users_model.dart';
import 'package:petlink_flutter_app/model/pets_model.dart';
import 'package:petlink_flutter_app/app_pages/widgets/edit_additional_user_info.dart';
import 'dart:typed_data';
import 'package:petlink_flutter_app/app_pages/widgets/build_user_image.dart';
import 'package:petlink_flutter_app/app_pages/mypets_page.dart';
import 'package:petlink_flutter_app/app_pages/requests_page.dart';
import 'dart:math';



class AccountPage extends StatefulWidget {
  const AccountPage({
    super.key,
    required this.userId,
    required this.email,
  });

  final int userId;
  final String email;

  @override
  _MyadditionalUserInfoState createState() => _MyadditionalUserInfoState();
}

class _MyadditionalUserInfoState extends State<AccountPage> {
  late Future<AdditionalUserInfo> additionalUserInfo;
  late Future<Uint8List> userImage;
  late Future<List<Pet>> pets;

List<String> imagePaths = [
    'assets/images/bird_pattern_backgrund.jpg',
    'assets/images/cats_pattern_background.png',
    'assets/images/dog_patterns_background.jpg',
];

  @override
  void initState() {
    super.initState();
    additionalUserInfo =
        AuthService().getAdditionalUserInfoByUserId(widget.userId);
    userImage = SupabaseService().getUserImageBytes('');
    pets = PetService().getPetsByUserId(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
     Random random = Random();
    String randomImagePath = imagePaths[random.nextInt(imagePaths.length)];
    return Scaffold(
      body: FutureBuilder<AdditionalUserInfo>(
        future: additionalUserInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final addinfo = snapshot.data!;
            debugPrint(snapshot.data.toString() + "Entra aqui");
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              body: Stack(
                children: [
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image:  DecorationImage(
                            image: AssetImage(randomImagePath),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: (Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            color: Color.fromARGB(255, 66, 66, 66).withOpacity(0.5),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.5,
                            ))),
                      )),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 30),

                                /// Nombre del usuario
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomeWidgetText(
                                      text: loggedUserName,
                                      isBold: true,
                                      size: 25,
                                    ),
                                    Text(" | "),
                                    InfoItemProfileExtra(
                                      icon: Icons.cake_rounded,
                                      text: addinfo.age.toString(),
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),

                                /// "Espaciador"
                                const SizedBox(height: 13),

                                /// Descripción
                                CustomeWidgetText(
                                    text: addinfo.slogan,
                                    isBold: false,
                                    size: 20),

                                /// Espaciador
                                const SizedBox(height: 20),

                                /// Segunda descripción
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InfoItemProfile(
                                      icon: Icons.location_on,
                                      text: addinfo.city,
                                      size: 25,
                                      color: Colors.black,
                                    ),
                                    Text("|"),
                                    InfoItemProfile(
                                      icon: Icons.home,
                                      text: addinfo.foster ? "Si" : "No",
                                      size: 25,
                                      color: Colors.black,
                                    ),
                                    Text("|"),
                                    FutureBuilder<List<Pet>>(
                                      future: pets,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Text(
                                              'Loading...'); // Muestra "Loading..." mientras se espera la carga de datos
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}'); // Muestra un mensaje de error si ocurre algún error
                                        } else if (snapshot.hasData) {
                                          final petsList = snapshot
                                              .data!; // Accede a los datos de la lista de mascotas
                                          return InfoItemProfile(
                                            icon: Icons.pets,
                                            text:
                                                '${petsList.length} Pets', // Muestra la longitud de la lista de mascotas
                                            size: 25,
                                            color: Colors.black,
                                          );
                                        } else {
                                          return Text(
                                              'No data available'); // Muestra un mensaje si no hay datos disponibles
                                        }
                                      },
                                    ),
                                    // Aquí puedes añadir más elementos si lo deseas
                                  ],
                                ),

                                /// Espaciador
                                const SizedBox(height: 20),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.bar_chart_rounded,
                                      size: 40,
                                    ),
                                    CustomeWidgetText(
                                        text: 'Mi area ',
                                        isBold: false,
                                        size: 20)
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child:
                                      Divider(height: 1.5, color: Colors.black),
                                ),

                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: () {
                                           Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RequestsPage()),
                                            );
                                          },
                                          icon: const Icon(
                                              Icons.insert_comment_rounded),
                                          label: const Text('Solicitudes',
                                              style: TextStyle(fontSize: 17)),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 255, 255, 255),
                                            side: const BorderSide(
                                                color: Colors.black),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                          ),
                                        ),
                                        OutlinedButton.icon(
                                          onPressed: () {
                                            
                                             Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyPetsPage(
                                                          userId:
                                                              widget.userId)),
                                            );
                                          },
                                          icon: const Icon(
                                              Icons.flutter_dash_rounded),
                                          label: const Text('Mascotas',
                                              style: TextStyle(fontSize: 17)),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 255, 255, 255),
                                            side: const BorderSide(
                                                color: Colors.black),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                          ),
                                        )
                                      ],
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Divider(
                                          height: 1.5, color: Colors.black),
                                    ),
                                    CustomeWidgetText(
                                      text: "Biografia",
                                      isBold: true,
                                      size: 15,
                                      color:
                                          const Color.fromARGB(255, 82, 53, 23),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    BiographyDescription(
                                        content: addinfo.description)
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                  buildUserImage(context, addinfo),
                  //buildUserImage(addinfo),
                  myfloatingbutton(
                      xpos: 100,
                      ypos: 220,
                      size: 0,
                      userId: widget.userId,
                      additionalUserInfo: addinfo,
                      email: widget.email),
                ],
              ),
            );
          } else {
            return Center(child: Text('No page available'));
          }
        },
      ),
    );
  }
}

class CustomeWidgetText extends StatelessWidget {
  CustomeWidgetText({
    super.key,
    required this.text,
    required this.isBold,
    required this.size,
    this.color = Colors.black,
  });

  final String text;
  final bool isBold;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: size,
            color: color));
  }
}

class InfoItemProfile extends StatelessWidget {
  InfoItemProfile(
      {super.key,
      required this.icon,
      required this.text,
      required this.size,
      required this.color});

  final IconData icon;
  final String text;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: size, color: color),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class InfoItemProfileExtra extends StatelessWidget {
  InfoItemProfileExtra({
    Key? key,
    required this.icon,
    required this.text,
    required this.size,
    required this.color,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          alignment: Alignment.center,
          height: size + 15, // 15 is the padding
          child: Icon(icon, size: size, color: color),
        ),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class BiographyDescription extends StatelessWidget {
  BiographyDescription({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(content, textAlign: TextAlign.justify),
      ],
    );
  }
}

class myfloatingbutton extends StatelessWidget {
  myfloatingbutton({
    Key? key,
    required this.xpos,
    required this.ypos,
    required this.size,
    required this.userId,
    required this.additionalUserInfo,
    required this.email,
  });

  final double xpos;
  final double ypos;
  final double size;
  final int userId;
  final AdditionalUserInfo additionalUserInfo;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: xpos,
      top: ypos,
      child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return EditUserInfoWidget(
                    email: email,
                  );
                },
              );
            },
            icon: const Icon(Icons.edit),
          )),
    );
  }
}




/*
class UserImage extends StatelessWidget {
   UserImage({
    Key? key,
    required this.imageId,
  }) : super(key: key);

  final String imageId;
  final supabase = SupabaseService();

  @override
  Widget build(BuildContext context) {

    debugPrint("ooooooooooooooo $imageId");

    
  }
}*/