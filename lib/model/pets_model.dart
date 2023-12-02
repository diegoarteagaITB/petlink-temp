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
  List<String> adoptionRequests;

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
    required this.adoptionRequests
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
      adoptionRequests: json['adoptionsrequests'] != null
          ? List <String>.from(json['adoptionrequests'])
          : [],
    );
  }

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
        petId: map['pet_id'],
        userId: map['pet_user_id'],
        inAdoption: map['pet_in_adoption'],
        name: map['pet_name'],
        type: map['pet_type'],
        gender: map['pet_gender'],
        breed: map['pet_breed'],
        castrated: map['pet_castrated'],
        medHistId: map['pet_med_hist_id'],
        imgId: map['pet_img_id'],
        adoptionRequests: map['adoptionsrequests'] != null
          ? List <String>.from(map['adoptionrequests'])
          : [],
      );
  }
}
