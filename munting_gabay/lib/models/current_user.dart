class CurrentUser {
  final String id;
  String username;
  String name;
  final String role;
  DateTime birthdate;
  String address;
  final String email;
  bool pinStatus;
  String pin;
  String avatarPath;

  CurrentUser({
    required this.id,
    required this.username,
    required this.name,
    required this.role,
    required this.birthdate,
    required this.address,
    required this.email,
    required this.pinStatus,
    required this.pin,
    required this.avatarPath,
  });

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "name": name,
      "role": role,
      "birthdate": birthdate,
      "address": address,
      "email": email,
      "pinStatus": pinStatus,
      "pin": pin,
      "avatarPath": avatarPath,
    };
  }
}
