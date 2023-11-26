import 'dart:convert';
import 'package:http/http.dart' as http;
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
      return items.map((json) => Doctor.fromJson(json)).toList();
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
      return items.map((json) => Service.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }
}
