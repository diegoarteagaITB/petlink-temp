class AdditionalUserInfo {
  int idUser;
  int age;
  String city;
  String slogan;
  String description;
  bool foster;
  

  AdditionalUserInfo({
    required this.idUser,
    required this.age,
    required this.city,
    required this.slogan,
    required this.description,
    required this.foster,
  });

  factory AdditionalUserInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalUserInfo(
      idUser: json['idUser'],
      age: json['age'],
      city: json['city'],
      slogan: json['slogan'],
      description: json['description'],
      foster: json['foster'],
    );
  }

  factory AdditionalUserInfo.fromMap(Map<String, dynamic> map) {
    return AdditionalUserInfo(
      idUser: map['idUser'],
      age: map['age'],
      city: map['city'],
      slogan: map['slogan'],
      description: map['description'],
      foster: map['foster'],
    );
  }
}
