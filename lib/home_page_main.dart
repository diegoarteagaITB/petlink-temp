import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/app_pages/account_page/account_page_main.dart';
import 'package:petlink_flutter_app/app_pages/pets_page/pets_page_main.dart';
import 'package:petlink_flutter_app/app_pages/user_home_page/user_home_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPage = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  Color? _homePageBgColor(int index) {
    switch (index) {
      case 0:
        return const Color.fromARGB(255, 228, 229, 228);
      case 1:
        return const Color.fromARGB(255, 228, 229, 228);
      case 2:
        return const Color.fromARGB(255, 228, 229, 228);
    }
    return null;
  }

  final List<Widget> _pages = [
    const UserHomePage(),
    const PetsPage(),
    const AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _homePageBgColor(selectedPage),
      body: _pages[selectedPage],
      bottomNavigationBar: FluidNavBar(
        icons: [
          FluidNavBarIcon(
              icon: Icons.home,
              backgroundColor: Colors.grey,
              extras: {"label": "home"}),
          FluidNavBarIcon(
              icon: Icons.pets,
              backgroundColor: Colors.grey,
              extras: {"label": "pets"}),
          FluidNavBarIcon(
              icon: Icons.person,
              backgroundColor: Colors.grey,
              extras: {"label": "account"}),
        ],
        onChange: _navigateBottomBar,
        style: const FluidNavBarStyle(
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
