import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:medical_appointments/application/domain/entity/appointment_record.dart';
import 'package:medical_appointments/application/domain/entity/doctor.dart';
import 'package:medical_appointments/application/domain/entity/service.dart';

class ApiClient {
  Future<List<Doctor>> fetchDoctors() async {
    final response = await http.post(
      Uri.parse('https://api.tiamomed.by/api/v1/test/doctors'),
      headers: {
        'Login': 'narisuemvse',
        'Password': '!by123narisuemvse',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final items = data['items'] as List;
      return items.map((json) => Doctor.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  Future<List<Service>> fetchServices(String doctorKod) async {
    final response = await http.post(
      Uri.parse('https://api.tiamomed.by/api/v1/test/services'),
      headers: {
        'Login': 'narisuemvse',
        'Password': '!by123narisuemvse',
      },
      body: {
        'Kod': doctorKod,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final items = data['items'] as List;
      return items.map((json) => Service.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<void> addNewRecord(AppointmentRecord record) async {
    final response = await http.post(
      Uri.parse('https://api.tiamomed.by/api/v1/test/add_new_record'),
      headers: {
        'Login': 'narisuemvse',
        'Password': '!by123narisuemvse',
      },
      body: {
        'doctor': record.selectedDoctor.kod,
        'services': record.selectedServices.map((x) => x.kod).toString(),
        'date': DateFormat('yyyy-MMMM-DD').format(record.selectedDate),
        'time': DateFormat.Hm().format(record.selectedDate),
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to add new record');
    }
  }
}
