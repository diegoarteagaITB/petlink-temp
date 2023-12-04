class Users {
  int id;
  String name;
  String dni;
  String email;
  String password;
  String phone;
  String profileImg;

  Users({
    required this.id,
    required this.name,
    required this.dni,
    required this.email,
    required this.password,
    required this.phone,
    required this.profileImg,
  });
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      name: json['name'],
      dni: json['dni'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      profileImg: json['imgProfile'],
    );
  }
}
