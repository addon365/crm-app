import 'dart:convert';

import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/model/appointment_view_model.dart';
import 'package:crm_app/model/employee.dart';

import 'package:http/http.dart' as http;

class AppointmentRepository {
  static AppointmentRepository repository;

  static AppointmentRepository getRepository() {
    if (repository == null) {
      repository = new AppointmentRepository();
    }
    return repository;
  }

  Future<List<AppointmentViewModel>> fetchAppointments() async {
    String url = '$baseUrl/Appointments';
    String userId = currentUser.id;
    String queryParam = "$url?userId=$userId";
    var result = await http.get(queryParam);
    if (result.statusCode == 200) {
      var mapList = List<Map<String, dynamic>>.from(json.decode(result.body));
      return AppointmentViewModel.fromJsonArray(mapList);
    } else {
      return null;
    }
  }

  Future<List<Employee>> fetchEmployees() async {
    String url = '$baseUrl/Employees';
    var result = await http.get(url);
    if (result.statusCode == 200) {
      var mapList = List<Map<String, dynamic>>.from(json.decode(result.body));
      return Employee.fromJsonArray(mapList);
    } else {
      return null;
    }
  }

  Future<String> putAppointment(
      AppointmentViewModel appointmentViewModel) async {
    appointmentViewModel.updatedById = currentUser.id;
    String url = '$baseUrl/Appointments';
    String appointmentJson = json.encode(appointmentViewModel.toJson());
    print(appointmentJson);
    var result = await http.put(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: appointmentJson);
    if (result.statusCode == 200) {
      print(result.body);
      return null;
    } else {
      var map = json.decode(result.body);

      return map["Message"];
    }
  }
}
