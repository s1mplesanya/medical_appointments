import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:medical_appointments/application/domain/entity/doctor.dart';
import 'package:medical_appointments/application/domain/entity/service.dart';
part 'appointment_record.g.dart';

@HiveType(typeId: 3)
class AppointmentRecord extends HiveObject {
  @HiveField(0)
  final Doctor selectedDoctor;
  @HiveField(1)
  final List<Service> selectedServices;
  @HiveField(2)
  final DateTime selectedDate;

  AppointmentRecord({
    required this.selectedDoctor,
    required this.selectedServices,
    required this.selectedDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'selectedDoctor': selectedDoctor.toMap(),
      'selectedServices': selectedServices.map((x) => x.toMap()).toList(),
      'selectedDate': selectedDate.millisecondsSinceEpoch,
    };
  }

  factory AppointmentRecord.fromMap(Map<String, dynamic> map) {
    return AppointmentRecord(
      selectedDoctor:
          Doctor.fromMap(map['selectedDoctor'] as Map<String, dynamic>),
      selectedServices: List<Service>.from(
        (map['selectedServices'] as List<int>).map<Service>(
          (x) => Service.fromMap(x as Map<String, dynamic>),
        ),
      ),
      selectedDate:
          DateTime.fromMillisecondsSinceEpoch(map['selectedDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppointmentRecord.fromJson(String source) =>
      AppointmentRecord.fromMap(json.decode(source) as Map<String, dynamic>);
}
