class Doctor {
  final String id;
  final String name;
  final String username;
  final String status;
  final String address;
  final DateTime birthdate;
  final String email;
  final String clinicName;
  final String clinicAddress;
  final String phoneNumber;
  final String profilePicture;

  Doctor({
    required this.id,
    required this.name,
    required this.username,
    required this.status,
    required this.address,
    required this.birthdate,
    required this.email,
    required this.clinicName,
    required this.clinicAddress,
    required this.phoneNumber,
    required this.profilePicture,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "username": username,
      "status": status,
      "address": address,
      "birthdate": birthdate,
      "email": email,
      "clinic_name": clinicName,
      "clinic_address": clinicAddress,
      "phone_number": phoneNumber,
      "profile_picture": profilePicture,
    };
  }
}
