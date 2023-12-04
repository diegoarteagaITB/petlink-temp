import 'dart:ffi';

import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/app_pages/account_page_main.dart';
import 'package:petlink_flutter_app/app_pages/pets_page_main.dart';
import 'package:petlink_flutter_app/app_pages/user_home_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.fullName, required this.email,required this.userId});

 
  final String email;
  final String fullName;
  final int userId;

  @override
  State<MyHomePage> createState() => _MyHomePageState(fullName, userId);
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPage = 1;

  final String fullName;
  final int userId;

  _MyHomePageState(this.fullName, this.userId);

  void _navigateBottomBar(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    _pages = [
      PetsPage(userId: userId, fullName: fullName),
      UserHomePage(
        fullName: fullName,
        email: widget.email,
        userId: userId,
      ),
      const AccountPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[selectedPage],
      bottomNavigationBar: FluidNavBar(
        icons: [
          FluidNavBarIcon(
              icon: Icons.pets,
              backgroundColor: const Color.fromARGB(255, 4, 40, 71),
              extras: {"label": "pets"}),
          FluidNavBarIcon(
              icon: Icons.home,
              backgroundColor: const Color.fromARGB(255, 4, 40, 71),
              extras: {"label": "home"}),
          FluidNavBarIcon(
              icon: Icons.person,
              backgroundColor: const Color.fromARGB(255, 4, 40, 71),
              extras: {"label": "account"}),
        ],
        onChange: (index) => _navigateBottomBar(index),
        style: const FluidNavBarStyle(
            barBackgroundColor: Color.fromARGB(255, 4, 40, 71),
            iconBackgroundColor: Colors.white,
            iconUnselectedForegroundColor: Colors.white,
            iconSelectedForegroundColor: Colors.white),
        scaleFactor: 1.5,
        defaultIndex: 1,
        itemBuilder: (icon, item) => Semantics(
          label: icon.extras!["label"],
          child: item,
        ),
      ),
    );
  }
}
