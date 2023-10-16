import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/home_page/home_page_bottom_nav.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final Text title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget? _child;

  @override
  void initState() {
    _child = const MyHomePage(title: Text("Home", style: TextStyle(fontFamily: 'BalooDa2')));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(151, 248, 242, 0.8),
      bottomNavigationBar: bottomNavigation(handleNavigationChange: _handleNavigationChange),
    );
  }

  // TO-DO -> Falta crear las paginas y adaptar el bottom a cada una de ellas.
  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = const MyHomePage(title: Text("Home", style: TextStyle(fontFamily: 'BalooDa2')));
          break;
        case 1:
          _child = const MyHomePage(title: Text("Pets", style: TextStyle(fontFamily: 'BalooDa2')));
          break;
        case 2:
          _child = const MyHomePage(title: Text("Account", style: TextStyle(fontFamily: 'BalooDa2')));
          break;
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: const Duration(milliseconds: 100),
        child: _child,
      );
    });
  }
}