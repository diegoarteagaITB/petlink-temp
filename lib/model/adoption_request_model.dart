class AdoptionRequests {
  int request_id;
  int requesting_user_id;
  int pet_id;

  AdoptionRequests({
    required this.request_id,
    required this.requesting_user_id,
    required this.pet_id,
  });

  factory AdoptionRequests.fromJson(Map<String, dynamic> json) {
    return AdoptionRequests(
      request_id: json['id'],
      requesting_user_id: json['requestingUserid'],
      pet_id: json['petId'],
    );
  }

  factory AdoptionRequests.fromMap(Map<String, dynamic> map) {
    return AdoptionRequests(
      request_id: map['id'],
      requesting_user_id: map['requestingUserid'],
      pet_id: map['petId'],
    );
  }
}
