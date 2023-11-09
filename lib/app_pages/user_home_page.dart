import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

import 'package:petlink_flutter_app/app_pages/widgets/card_flip_animation.dart';

import 'package:text_scroll/text_scroll.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key, required this.fullName});

  final String fullName;

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  Widget build(BuildContext context) {
    enterFullScreen();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'BalooDa2'),
      home: Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 3, 25, 44),
            toolbarHeight: 62,
            leadingWidth: 110,
            leading: Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Hello,",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextScroll(
                    '${widget.fullName}          ',
                    style: const TextStyle(fontSize: 15),
                    mode: TextScrollMode.endless,
                    pauseBetween: const Duration(milliseconds: 500),
                    velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                  )
                ],
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () => exitFullScreen(),
                  icon: const Icon(Icons.person))
            ]),
        backgroundColor: const Color.fromARGB(255, 3, 25, 44),
        body: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  width: 350,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'PETS',
                      style: TextStyle(
                          fontFamily: 'BalooDa2',
                          fontSize: 30,
                          color: Colors.white),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SizedBox(
                      width: 350, height: 510, child: CardFlipAnimation()),
                ),
                Container(
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 104, 0, 249),
                        Color.fromARGB(255, 48, 11, 96)
                      ],
                    ),
                  ),
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 15),
                            child: Icon(Icons.pets),
                          ),
                          const Text(
                            'Add pet',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  width: 350,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'VACUNAS',
                      style: TextStyle(
                          fontFamily: 'BalooDa2',
                          fontSize: 30,
                          color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 350,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 20, 220, 163),
                          Color.fromARGB(255, 67, 104, 214),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 350,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'HISTORIAL MÉDICO',
                      style: TextStyle(
                          fontFamily: 'BalooDa2',
                          fontSize: 30,
                          color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: 350,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 20, 220, 163),
                          Color.fromARGB(255, 67, 104, 214),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }
}
