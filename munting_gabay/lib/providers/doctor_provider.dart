import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart' show ChangeNotifier;

import '../models/doctor.dart';
import 'current_user_provider.dart';

class DoctorProvider with ChangeNotifier {
  bool _isDoctorLoading = true;

  List<Doctor> _doctors = [];
  Doctor? _selectedDoctor;
  String _key = "";
  Timer? _searchTimer;

  // initialize provider
  DoctorProvider({CurrentUserProvider? provider}) {
    final auth = provider?.getAuth;

    if (auth == null) {
      return;
    }

    FirebaseFirestore.instance
        .collection("users")
        .where("role", isEqualTo: "DOCTORS")
        .snapshots()
        .listen(
      (docs) {
        if (docs.docs.isEmpty) {
          _isDoctorLoading = false;

          notifyListeners();
          return;
        }

        final List<Doctor> doctors = docs.docs.map(
          (doc) {
            final data = doc.data();

            return Doctor(
              id: doc.id,
              name: data["name"],
              username: data["username"],
              status: data["status"],
              address: data["address"],
              birthdate: data["birthdate"].toDate(),
              email: data["email"],
              clinicName: data["clinic_name"],
              clinicAddress: data["clinic_address"],
              phoneNumber: data["phone_number"],
              profilePicture: data["profile_picture"],
            );
          },
        ).toList();

        _doctors = doctors;
        _isDoctorLoading = false;

        notifyListeners();
      },
    ).onError(
      (error) {
        if (kDebugMode) {
          print(error);
        }

        _isDoctorLoading = false;
        _doctors.clear();
        notifyListeners();
      },
    );
  }

  // get loading status
  bool get isDoctorLoading => _isDoctorLoading;

  // get selected doctor
  Doctor? get getSelectedDoctor => _selectedDoctor;

  // set selected doctor
  void setSelectedDoctor({required Doctor doctor}) {
    _selectedDoctor = doctor;
    notifyListeners();
  }

  // set search key
  void setSearchKey({required String key}) {
    _searchTimer?.cancel();
    _searchTimer = Timer(
      const Duration(milliseconds: 500),
      () {
        _key = key;

        notifyListeners();
      },
    );
  }

  // clear search key
  void clearSearchKey() {
    _key = "";
  }

  // get search key
  String get getSearchKey => _key;

  // filtered doctors getter
  List<Doctor> get getFilteredDoctors => _doctors
      .where(
        (doctor) => doctor.name.toLowerCase().contains(_key.toLowerCase()),
      )
      .toList();
}
