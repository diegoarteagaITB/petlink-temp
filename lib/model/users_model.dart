class User {
  int id;
  String name;
  String dni;
  String phone;
  String email;
  String password;

  String profileImg;

  User({
    required this.id,
    required this.name,
    required this.dni,
    required this.phone,
    required this.email,
    required this.password,
    required this.profileImg,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      dni: json['dni'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
      profileImg: json['img_profile'],
    );
  }
}
