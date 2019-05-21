import 'package:crm_app/model/appointment-status.dart';
import 'package:crm_app/model/customer.dart';

class Appointment {
  String id;
  AppointmentStatus currentStatus;
  Customer customer;
  DateTime appointmentDate;

  Appointment(
      {this.id, this.currentStatus, this.customer, this.appointmentDate});

  static List<Appointment> fromJsonArray(List<Map<String, dynamic>> mapList) {
    List<Appointment> appointmentList = new List<Appointment>();
    mapList.forEach((map) {
      appointmentList.add(Appointment.fromJson(map));
    });
    return appointmentList;
  }

  static Appointment fromJson(Map<String, dynamic> map) {
    return Appointment(
        id: map['id'],
        customer: Customer.fromJson(map['customer']),
        currentStatus: AppointmentStatus.fromJson(map['currentStatus']));
  }

  Map<String, dynamic> toJson() {
    return {
      "Id": id,
      "CustomerId": customer.id,
      "AppiontmentDate": appointmentDate,
      "currentStatus": {
        "StatusId": currentStatus.status.id,
        "Comments": currentStatus.comments,
        "UpdatedById": currentStatus.updatedBy.id,
        "AssignedToId": currentStatus.assignedTo.id
      }
    };
  }
}
