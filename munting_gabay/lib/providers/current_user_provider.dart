import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart'
    show BuildContext, ChangeNotifier, ScaffoldMessenger, SnackBar, Text;
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../models/current_user.dart';

class CurrentUserProvider with ChangeNotifier {
  bool _isCurrentUserLoading = true;
  User? _auth;
  CurrentUser? _currentUser;

  // initialize getters
  bool get isCurrentUserLoading => _isCurrentUserLoading;
  User? get getAuth => _auth;
  CurrentUser? get currentUser => _currentUser;

  // initialize provider
  CurrentUserProvider() {
    FirebaseAuth.instance.authStateChanges().listen(
      (auth) {
        _auth = auth;
        // _authStreamController.add(auth);

        if (auth == null) {
          _currentUser = null;
          _isCurrentUserLoading = true;

          notifyListeners();
          return;
        }

        getCurrentUserData();
      },
    );
  }

  // fetch user data
  Future<void> getCurrentUserData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(_auth!.uid)
        .get()
        .then(
      (doc) {
        if (!doc.exists) {
          throw Exception("User not found.");
        }

        final data = doc.data()!;
        _currentUser = CurrentUser(
          id: doc.id,
          username: data["username"],
          name: data["name"],
          role: data["role"],
          birthdate: data["birthdate"].toDate(),
          address: data["address"],
          email: data["email"],
          pinStatus: data["pinStatus"],
          pin: data["pin"],
          avatarPath: data["avatarPath"],
        );

        _isCurrentUserLoading = false;

        notifyListeners();
        return;
      },
    ).onError(
      (error, stackTrace) {
        if (kDebugMode) {
          print(error);
        }

        _isCurrentUserLoading = false;

        notifyListeners();
        return;
      },
    );
  }

  // update profile picture
  Future<void> updateProfilePicture({
    required BuildContext context,
    required File file,
  }) async {
    EasyLoading.show(status: "Updating Profile");

    String downloadURL = "";
    final uploadTask =
        FirebaseStorage.instance.ref().child('avatars/${_currentUser?.id}.jpg');

    await uploadTask.putFile(file).whenComplete(
      () async {
        downloadURL = await uploadTask.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser?.id)
            .update({'avatarPath': downloadURL});

        // delete previous profile
        await FirebaseStorage.instance
            .refFromURL(_currentUser!.avatarPath)
            .delete()
            .then(
          (value) {
            _currentUser?.avatarPath = downloadURL;

            notifyListeners();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Avatar updated successfully')),
            );
          },
        );
      },
    );
  }

  // update current user data
  Future<void> updateUserData({
    required BuildContext context,
    required CurrentUser currentUser,
  }) async {
    EasyLoading.show(status: "Updating Profile...");

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.id)
        .update(
          currentUser.toMap(),
        )
        .then(
      (value) {
        // update local user data
        _currentUser = currentUser;
        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User data updated successfully.'),
          ),
        );
      },
    ).catchError(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error updating user data. Plase try again.')),
        );
      },
    ).whenComplete(
      () => EasyLoading.dismiss(),
    );
  }

  // update pin number
  Future<bool> updatePin({
    required BuildContext context,
    required String pin,
  }) async {
    EasyLoading.show(status: "Updating pin");

    return await FirebaseFirestore.instance
        .collection("users")
        .doc(_currentUser?.id)
        .update({"pin": pin}).then(
      (value) {
        _currentUser?.pin = pin;
        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pin updated successfully.'),
          ),
        );

        return true;
      },
    ).catchError(
      (error) {
        if (kDebugMode) {
          print(error);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error updating pin.'),
          ),
        );

        return false;
      },
    ).whenComplete(
      () => EasyLoading.dismiss(),
    );
  }

  // update pin status
  Future<void> updatePinStatus({
    required BuildContext context,
    required bool pinStatus,
  }) async {
    EasyLoading.show(status: "Updating pin status");

    await FirebaseFirestore.instance
        .collection("users")
        .doc(_currentUser?.id)
        .update({"pinStatus": pinStatus}).then(
      (value) {
        _currentUser?.pinStatus = pinStatus;
        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pin status updated successfully.'),
          ),
        );
      },
    ).catchError(
      (error) {
        if (kDebugMode) {
          print(error);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error updating pin status.'),
          ),
        );
      },
    ).whenComplete(
      () => EasyLoading.dismiss(),
    );
  }
}
