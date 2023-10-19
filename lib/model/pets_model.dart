class Pet {
  int petId;
  int userId;
  bool inAdoption;
  String name;
  String type;
  String gender;
  String breed;
  bool castrated;
  String medHistId;
  String imgId;

  Pet({
    required this.petId,
    required this.userId,
    required this.inAdoption,
    required this.name,
    required this.type,
    required this.gender,
    required this.breed,
    required this.castrated,
    required this.medHistId,
    required this.imgId,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      petId: json['id'],
      userId: json['userId'],
      inAdoption: json['inAdoption'],
      name: json['name'],
      type: json['type'],
      gender: json['gender'],
      breed: json['breed'],
      castrated: json['castrated'],
      medHistId: json['medHistId'],
      imgId: json['imgId'],
    );
  }
}
