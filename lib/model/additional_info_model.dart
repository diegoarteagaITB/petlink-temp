class AdditionalUserInfo {
  int idUser;
  int age;
  String city;
  String slogan;
  String description;
  bool foster;
  String imgId;
  

  AdditionalUserInfo({
    required this.idUser,
    required this.age,
    required this.city,
    required this.slogan,
    required this.description,
    required this.foster,
    required this.imgId,
  });

  factory AdditionalUserInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalUserInfo(
      idUser: json['userid'] ?? 0,
      age: json['age'] ?? 18,
      city: json['city'] ?? 'Slap City',
      slogan: json['slogan']?? 'DTS',
      description: json['description']?? 'easy friend',
      foster: json['foster']?? true,
      imgId: json['imgId']?? 'random imge txt',
    );
  }

  factory AdditionalUserInfo.fromMap(Map<String, dynamic> map) {
    return AdditionalUserInfo(
      idUser: map['userid'] ?? 0,
      age: map['age'] ?? 18,
      city: map['city'] ?? 'Slap City',
      slogan: map['slogan']?? 'DTS',
      description: map['description']?? 'easy friend',
      foster: map['foster']?? true,
      imgId: map['imgId']?? 'random imge txt',
    );
  }
}
