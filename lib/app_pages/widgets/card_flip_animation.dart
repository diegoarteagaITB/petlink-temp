import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:petlink_flutter_app/api/ktor/pet_service.dart';
import 'package:petlink_flutter_app/model/pets_model.dart';
import 'dart:math' as math;

class CardFlipAnimation extends StatefulWidget {
  const CardFlipAnimation({super.key});

  @override
  createState() => _CardFlipAnimationState();
}

class _CardFlipAnimationState extends State<CardFlipAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;
  late Future<List<Pet>> petsFuture;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    petsFuture = PetService().getPetsByUserId(1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_controller.status != AnimationStatus.forward) {
      if (_isFront) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      _isFront = !_isFront;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: _flipCard,
        child: Center(
          child: SizedBox(
            height: 510,
            child: Transform(
              transform: Matrix4.rotationY(_animation.value * math.pi),
              alignment: Alignment.center,
              child: _isFront ? _buildFront() : _buildBack(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFront() {
    return ClipRRect(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: Gradients.rainbowBlue,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "MY PETS",
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Tap to see",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(3.14),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 129, 207, 249),
              Color.fromARGB(255, 52, 111, 163)
            ],
            tileMode: TileMode.repeated,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: FutureBuilder<List<Pet>>(
          future: petsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Loading data...",
                    style:
                        TextStyle(fontFamily: 'BalooDa2', color: Colors.white),
                  ),
                ],
              );
            } else if (snapshot.hasData) {
              final pets = snapshot.data!;
              return _buildPetList(pets);
            } else {
              return const Text("No data available");
            }
          },
        ),
      ),
    );
  }

  Widget _buildPetList(List<Pet> pets) {
    return Padding(
      padding: const EdgeInsets.only(top: 9, bottom: 15),
      child: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (BuildContext context, int index) {
          final pet = pets[index];

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 5, 40, 71),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ),
                        ),
                        imageUrl: pet.imgId,
                        width: 120,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          pet.name,
                          style: const TextStyle(
                            fontFamily: 'BalooDa2',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 19,
                          ),
                        ),
                        Text(
                          pet.breed,
                          style: const TextStyle(
                            fontFamily: 'BalooDa2',
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          pet.castrated ? "Castrated" : "Not castrated",
                          style: const TextStyle(
                            fontFamily: 'BalooDa2',
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      width: 70,
                      height: 40,
                      child: TextButton(
                        onPressed: () => {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                            (states) => const Color(0xFFE4E5E4),
                          ),
                        ),
                        child: const Text(
                          "See more",
                          style: TextStyle(
                            fontFamily: 'BalooDa2',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
