import 'dart:convert';

import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/model/Status.dart';
import 'package:crm_app/model/appointment.dart';
import 'package:http/http.dart' as http;

class AppointmentRepository {
  static AppointmentRepository repository;

  static AppointmentRepository getRepository() {
    if (repository == null) {
      repository = new AppointmentRepository();
    }
    return repository;
  }

  Future<List<Appointment>> fetchAppointments() async {
    String url = '$baseUrl/Appointments';
    var result = await http.get(url);
    if (result.statusCode == 200) {
      var mapList = List<Map<String, dynamic>>.from(json.decode(result.body));
      return Appointment.fromJsonArray(mapList);
    } else {
      return null;
    }
  }

  Future<List<Status>> fetchStatuses() async {
    String url = '$baseUrl/Statuses';
    var result = await http.get(url);
    if (result.statusCode == 200) {
      var mapList = List<Map<String, dynamic>>.from(json.decode(result.body));
      return Status.fromJsonArray(mapList);
    } else {
      return null;
    }
  }
}
