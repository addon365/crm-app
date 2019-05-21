import 'dart:convert';

import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/model/Status.dart';
import 'package:crm_app/model/appointment.dart';
import 'package:crm_app/model/employee.dart';
import 'package:crm_app/repository/user_repository.dart';
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
    String userId=UserRepository.currentUser.id;
    String queryParam="$url?userId=$userId";
    var result = await http.get(queryParam);
    if (result.statusCode == 200) {
      var mapList = List<Map<String, dynamic>>.from(json.decode(result.body));
      return Appointment.fromJsonArray(mapList);
    } else {
      return null;
    }
  }

  Future<List<Status>> fetchStatuses() async {
    String url = '$baseUrl/StatusesMaster';
    var result = await http.get(url);
    if (result.statusCode == 200) {
      var mapList = List<Map<String, dynamic>>.from(json.decode(result.body));
      return Status.fromJsonArray(mapList);
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

  Future<bool> putAppointment(Appointment appointment) async {
    String url = '$baseUrl/Appointments';
    String appointmentJson = json.encode(appointment.toJson());
    print(appointmentJson);
    var result = await http.put(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: appointmentJson);
    if (result.statusCode == 200) {
      print(result.body);
      return true;
    } else {
      print(result.body);
      return false;
    }
  }
}
