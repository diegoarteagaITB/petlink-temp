import 'package:flutter/material.dart';
import 'home_page/home_page_main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetLink',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(
            1, 98, 94, 1.0)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: Text("Home", style: TextStyle(color: Colors.white, fontFamily: 'BalooDa2', fontSize: 23, fontWeight: FontWeight.w500))),
    );
  }
}
