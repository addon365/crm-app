import 'package:crm_app/model/appointment-status.dart';
import 'package:crm_app/model/customer.dart';

class Appointment {
  String id;
  List<AppointmentStatus> statuses;
  Customer customer;

  Appointment({this.id, this.statuses, this.customer});

  static List<Appointment> fromJsonArray(List<Map<String, dynamic>> mapList) {
    List<Appointment> appointmentList = new List<Appointment>();
    mapList.forEach((map) {
      appointmentList.add(Appointment.fromJson(map));
    });
    return appointmentList;
  }

  static Appointment fromJson(Map<String, dynamic> map) {
    var statusesMap =
        List<Map<String, dynamic>>.from(map['appointmentStatuses']);
    return Appointment(
        id: map['id'],
        customer: Customer.fromJson(map['customer']),
        statuses: AppointmentStatus.fromJsonArray(statusesMap));
  }
}
