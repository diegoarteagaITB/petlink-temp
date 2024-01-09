import 'dart:typed_data';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/api/supabase/supabase_service.dart';
import 'package:petlink_flutter_app/model/pets_model.dart';

Widget buildPetImage(Pet pet) {
  final supaService = SupabaseService();

  return Padding(
    padding: const EdgeInsets.all(10),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: FutureBuilder<Uint8List>(
        future: supaService.getImageBytes(pet.imgId),
        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox(
              width: 120,
              height: 80,
              child: CachedMemoryImage(
                uniqueKey: pet.imgId,
                bytes: snapshot.data,
                fit: BoxFit.fill,
              ),
            );
          } else {
            return const SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    ),
  );
}
