import 'package:crm_app/model/appointment-status.dart';

import 'lead.dart';

class Appointment {
  String id;
  AppointmentStatus currentStatus;
  Lead lead;
  DateTime appointmentDate;

  Appointment({this.id, this.currentStatus, this.lead, this.appointmentDate});

  static List<Appointment> fromJsonArray(List<Map<String, dynamic>> mapList) {
    List<Appointment> appointmentList = new List<Appointment>();
    if (mapList.length == 0) return appointmentList;

    mapList.forEach((map) {
      appointmentList.add(Appointment.fromJson(map));
    });
    return appointmentList;
  }

  static Appointment fromJson(Map<String, dynamic> map) {
    return Appointment(
        id: map['id'],
        lead: Lead.fromJson(map['lead']),
        currentStatus: AppointmentStatus.fromJson(map['currentStatus']));
  }

  Map<String, dynamic> toJson() {
    return {
      "Id": id,
      "LeadId": lead.id,
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
