
import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/api/ktor/authentication_service.dart';
import 'package:petlink_flutter_app/global_variables.dart';
import 'package:petlink_flutter_app/model/additional_info_model.dart';
import 'package:petlink_flutter_app/model/users_model.dart';
import 'package:petlink_flutter_app/app_pages/widgets/edit_additional_user_info.dart';


class AccountPage extends StatefulWidget {
  const AccountPage({super.key,
      required this.userId});


  final int userId;

 @override
  _MyadditionalUserInfoState createState() => _MyadditionalUserInfoState();
}

class _MyadditionalUserInfoState extends State<AccountPage> {
  late Future<List<AdditionalUserInfo>> additionalUserInfoFuture;

  @override
  void initState() {
    super.initState();
    additionalUserInfoFuture = AuthService().getAdditionalUserInfoByUserId(widget.userId);
  }


@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AdditionalUserInfo>>(
        future: additionalUserInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final additionalUserInfo = snapshot.data!;
            return buildAdditionalUserInfo(additionalUserInfo);
          } else {
            return Center(child: Text('No pets available'));
          }
        },
      ),
    );
  }



Widget buildAdditionalUserInfo(List<AdditionalUserInfo> additionalUserInfo) {
    final addinfo = additionalUserInfo[0];
    return Scaffold(
      backgroundColor: Colors.black,
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
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://i.pinimg.com/originals/e2/45/0b/e2450b369b61a0bef3d165586996ab5f.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: (Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    color: Colors.black.withOpacity(0.5),
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
                        CustomeWidgetText(
                          text: loggedUserName,
                          isBold: true,
                          size: 25,
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              text: addinfo.foster == true ? "Yes" : "No",
                              size: 25,
                              color: Colors.black,
                            ),
                            Text("|"),
                             InfoItemProfile(
                              icon: Icons.pets,
                              text: "3",
                              size: 25,
                              color: Colors.black,
                            ),
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
                                text: 'My area ', isBold: false, size: 20)
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Divider(height: 1.5, color: Colors.black),
                        ),

                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon:
                                      const Icon(Icons.insert_comment_rounded),
                                  label: const Text('My requests',
                                      style: TextStyle(fontSize: 17)),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    side: const BorderSide(color: Colors.black),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                      Icons.favorite_outline_rounded),
                                  label: const Text('My favorites',
                                      style: TextStyle(fontSize: 17)),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    side: const BorderSide(color: Colors.black),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Divider(height: 1.5, color: Colors.black),
                            ),
                            CustomeWidgetText(
                              text: "Description",
                              isBold: true,
                              size: 15,
                              color:const Color.fromARGB(255, 82, 53, 23),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                             BiographyDescription(
                                content:
                                    addinfo.description)
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          myphoto(),
          myfloatingbutton(xpos: 100, ypos: 220, size: 0, userId: widget.userId),

        ],
        
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
      children: [
        Icon(icon, size: size, color: color),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
  myfloatingbutton({Key? key, required this.xpos, required this.ypos, required this.size, required this.userId});

  final double xpos;
  final double ypos;
  final double size;
  final int userId;

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
          borderRadius: BorderRadius.circular(100)
        ),
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditUserInfo(userId: userId),)
            );
          },
          icon: const Icon(Icons.edit),
        )
      ),
    );
  }
}

class myphoto extends StatelessWidget {
 myphoto({super.key});


 
  @override
  Widget build(BuildContext context) {
    return Positioned(
          right: (MediaQuery.of(context).size.width - 200) * 0.5,
          top: MediaQuery.of(context).size.height * 0.1,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0).withOpacity(0),
                
              ),
              child: const CircleAvatar(
                        radius: 65.0,
                        backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                        backgroundColor: Colors.white,
              )
              )
            );
}

Widget buildAdditionalUserInfo(AdditionalUserInfo additionalUserInfo) {
    return Column(
      children: [
        Text(additionalUserInfo.slogan, textAlign: TextAlign.justify),
      ],
    );
  }
}
