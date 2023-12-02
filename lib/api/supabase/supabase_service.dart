import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:petlink_flutter_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  void connection() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Supabase.initialize(
        url: "https://erejsubvqldpeklqhhrk.supabase.co",
        anonKey:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVyZWpzdWJ2cWxkcGVrbHFoaHJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MzQ5NjksImV4cCI6MjAxNjMxMDk2OX0.E-igWykPt8fXJnLHsXPw15qvaMnNzeOcwMAHma0hn-A");
  }

  Future<Uint8List> getImageBytes(String imgId) async {
    final object =
        await supabase.storage.from('images').download('pet_images/$imgId');

    debugPrint(object.toString());
    debugPrint(imgId.toString());
    return object;
  }
}
