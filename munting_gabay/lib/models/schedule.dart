class Schedule {
  final String? id;
  final String doctorId;
  final String patientId;
  final DateTime dateStart;
  final DateTime dateEnd;
  final String status;

  Schedule({
    this.id,
    required this.doctorId,
    required this.patientId,
    required this.dateStart,
    required this.dateEnd,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      "doctor_id": doctorId,
      "patient_id": patientId,
      "date_start": dateStart,
      "date_end": dateEnd,
      "status": status,
    };
  }
}
