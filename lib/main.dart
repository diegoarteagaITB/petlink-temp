import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/api/supabase/supabase_service.dart';
import 'package:petlink_flutter_app/app_pages/home_page_main.dart';
import 'package:petlink_flutter_app/app_pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: "https://erejsubvqldpeklqhhrk.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVyZWpzdWJ2cWxkcGVrbHFoaHJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MzQ5NjksImV4cCI6MjAxNjMxMDk2OX0.E-igWykPt8fXJnLHsXPw15qvaMnNzeOcwMAHma0hn-A");

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;
const String ipAddress = "http://192.168.1.31:8080";

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
      home: LoginPage(),
    );
  }
}
