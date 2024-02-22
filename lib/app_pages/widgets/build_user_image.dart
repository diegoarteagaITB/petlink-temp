import 'dart:typed_data';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/api/supabase/supabase_service.dart';
import 'package:petlink_flutter_app/model/additional_info_model.dart';
import 'package:petlink_flutter_app/model/pets_model.dart';

Widget buildUserImage(
    BuildContext context, AdditionalUserInfo additionalUserInfo) {
  final supaService = SupabaseService();
  final Size screenSize = MediaQuery.of(context).size;

  // Calcula las coordenadas X e Y para centrar el widget en la pantalla
  final double centerX =
      (screenSize.width - 200) / 2; // El ancho del widget es 120
  final double centerY =
      ((screenSize.height * 0.2)) / 2; // La altura del widget es 80

  return Positioned(
    left: centerX,
    top: centerY,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: FutureBuilder<Uint8List>(
        future: supaService.getUserImageBytes(additionalUserInfo.imgId),
        //future: supaService.getImageBytes(additionalUserInfo.imgId),
        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CircleAvatar(
              radius: 100,
              backgroundColor: Colors.transparent,
              backgroundImage: MemoryImage(
                  snapshot.data!), // Envuelve CachedMemoryImage con MemoryImage
            );
            /*return SizedBox(
              width: 120,
              height: 80,
              child: CachedMemoryImage(
                uniqueKey: additionalUserInfo.imgId,
                bytes: snapshot.data,
                fit: BoxFit.fill,
              ),
            );
            */
          } else {
            return SizedBox(
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
