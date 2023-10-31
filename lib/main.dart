import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/app_pages/home_page_main.dart';
import 'package:petlink_flutter_app/app_pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetLink',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(1, 98, 94, 1.0)),
        useMaterial3: true,
      ),
      home: MyHomePage(fullName: "Alejandro"),
    );
  }
}
