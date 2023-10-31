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

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
        petId: map['pet_id'],
        userId: map['pet_user_id'],
        inAdoption: map['pet_in_adoption'],
        name: map['pet_name'],
        type: map['pet_type'],
        gender: map['pet_gender'],
        breed: map['pet_gender'],
        castrated: map['pet_castrated'],
        medHistId: map['pet_med_hist_id'],
        imgId: map['pet_img_id']);
  }
}
