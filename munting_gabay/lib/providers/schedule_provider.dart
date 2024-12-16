import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart'
    show BuildContext, ScaffoldMessenger, SnackBar, Text;
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../models/doctor.dart';
import '../models/schedule.dart';
import 'current_user_provider.dart';
import 'doctor_provider.dart';

class ScheduleProvider extends DoctorProvider {
  bool _isScheduleLoading = true;
  User? _auth;
  Doctor? _selectedDoctor;

  final List<Schedule> _activeDoctorSchedule = [];
  final List<Schedule> _doctorScheduleHistory = [];
  final List<Schedule> _myScheduleReqest = [];
  final _todate = DateTime.now().copyWith(
    hour: 0,
    minute: 0,
    second: 0,
    millisecond: 0,
    microsecond: 0,
  );

  // initialize provider
  ScheduleProvider({
    CurrentUserProvider? currentUserProvider,
    DoctorProvider? doctorProvider,
  }) {
    _auth = currentUserProvider?.getAuth;
    final doctor = doctorProvider?.getSelectedDoctor;

    if (doctor != _selectedDoctor) {
      _selectedDoctor = doctor;
      _isScheduleLoading = true;
      loadDoctorSchedule();
    }
  }

  // load selected doctor schedule
  void loadDoctorSchedule() {
    FirebaseFirestore.instance
        .collection("schedules")
        .where(
          Filter.and(
            Filter("doctor_id", isEqualTo: _selectedDoctor!.id),
            Filter(
              "date_start",
              isGreaterThanOrEqualTo:
                  DateTime(_todate.year, _todate.month, _todate.day),
            ),
            Filter(
              "date_end",
              isLessThanOrEqualTo:
                  DateTime(_todate.year, _todate.month + 1, _todate.day),
            ),
          ),
        )
        .orderBy("date_start")
        .snapshots()
        .listen(
      (schedules) {
        // reset list values
        _activeDoctorSchedule.clear();
        _doctorScheduleHistory.clear();
        _myScheduleReqest.clear();

        if (schedules.docs.isEmpty) {
          _isScheduleLoading = false;
          notifyListeners();
          return;
        }

        for (var e in schedules.docs) {
          final DateTime start = e.get("date_start").toDate();
          final DateTime end = e.get("date_end").toDate();

          final sched = Schedule(
            id: e.id,
            doctorId: e.get("doctor_id"),
            patientId: e.get("patient_id"),
            dateStart: start.copyWith(millisecond: 0, microsecond: 0),
            dateEnd: end.copyWith(millisecond: 0, microsecond: 0),
            status: e.get("status"),
          );

          if (sched.patientId == _auth?.uid) {
            _myScheduleReqest.add(sched);
          }

          if (sched.status == "Completed" || sched.status == "Cancelled") {
            _doctorScheduleHistory.add(sched);

            continue;
          }

          _activeDoctorSchedule.add(sched);
        }

        print("terminating loading state");
        _isScheduleLoading = false;
        notifyListeners();
      },
    ).onError(
      (error) {
        if (kDebugMode) {
          print(error);
        }

        _isScheduleLoading = false;
        notifyListeners();
      },
    );
  }

  // get ScheduleLoading status
  bool get isScheduleLoading => _isScheduleLoading;

  // get doctor schedule
  List<Schedule> get getActiveDocSched => _activeDoctorSchedule;
  List<Schedule> get getDocSchedHistory => _doctorScheduleHistory;
  List<Schedule> get getRequestedSchedule => _myScheduleReqest;

  // save schedule request
  Future<bool> saveScheduleRequest({
    required BuildContext context,
    required Schedule schedule,
  }) async {
    final hasPendingRequest = _activeDoctorSchedule.indexWhere(
            (existingSchedule) =>
                schedule.patientId == existingSchedule.patientId) !=
        -1;

    if (hasPendingRequest) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Active request found. Request dismissed.'),
        ),
      );
      return false;
    }

    final isScheduleTaken = _activeDoctorSchedule.indexWhere(
          (existingSchedule) =>
              schedule.dateStart.isBefore(existingSchedule.dateEnd) &&
              schedule.dateEnd.isAfter(existingSchedule.dateStart),
        ) !=
        -1;

    if (isScheduleTaken) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Schedule overlaps with existing schedule.'),
        ),
      );
      return false;
    }

    EasyLoading.show(status: "Saving schedule request.");

    return await FirebaseFirestore.instance
        .collection("schedules")
        .add(schedule.toMap())
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Schedule request has been saved successfully."),
          ),
        );
        return true;
      },
    ).catchError(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to add schedule request."),
          ),
        );

        return false;
      },
    ).whenComplete(
      () => EasyLoading.dismiss(),
    );
  }

  // cancel schedule
  Future<void> cancelRequest({
    required BuildContext context,
    required Schedule schedule,
  }) async {
    EasyLoading.show(status: "Cancelling request");

    await FirebaseFirestore.instance
        .collection("schedules")
        .doc(schedule.id)
        .update({"status": "Cancelled"}).then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request has been cancelled successfully.'),
          ),
        );
      },
    ).catchError(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request cannot be cancelled.'),
          ),
        );
      },
    ).whenComplete(() => EasyLoading.dismiss());
  }
}
