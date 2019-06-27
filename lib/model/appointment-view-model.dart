import 'package:crm_app/dependency/constants.dart';
import 'package:intl/intl.dart';

class AppointmentViewModel {
  String id;

  String leadId;

  String leadName;
  DateTime appointmentDate;

  String previousStatus;

  String statusId;
  String status;
  DateTime dueDate;
  String assignedToId;

  String assignedTo;

  String comments;
  String updatedById;

  AppointmentViewModel(
      {this.id,
      this.leadId,
      this.leadName,
      this.appointmentDate,
      this.previousStatus,
      this.statusId,
      this.status,
      this.dueDate,
      this.assignedToId,
      this.assignedTo,
      this.comments,
      this.updatedById});

  static List<AppointmentViewModel> fromJsonArray(
      List<Map<String, dynamic>> mapList) {
    List<AppointmentViewModel> appointmentList =
        new List<AppointmentViewModel>();
    if (mapList.length == 0) return appointmentList;

    mapList.forEach((map) {
      appointmentList.add(AppointmentViewModel.fromJson(map));
    });
    return appointmentList;
  }

  static AppointmentViewModel fromJson(Map<String, dynamic> map) {


    return AppointmentViewModel(
      id: map["id"],
      leadId: map["leadId"],
      leadName: map["leadName"],
      appointmentDate: DateTime.parse(map["appointmentDate"]),
      previousStatus: map["previousStatus"],
      statusId: map["statusId"],
      status: map["status"],
      dueDate: DateTime.parse(map["dueDate"]),
      assignedToId: map["assignedToId"],
      assignedTo: map["assignedTo"],
      comments: map["comments"],
      updatedById: map["updatedById"],
    );
  }

  Map<String, dynamic> toJson() {
    DateTime d = DateTime.now();
    String strDueDate = Constants.formatDate(dueDate);
    String strAppointmentDate = Constants.formatDate(appointmentDate);
    return {
      "Id": id,
      "LeadId": leadId,
      "AppointmentDate": strAppointmentDate,
      "StatusId": statusId,
      "Comments": comments,
      "UpdatedById": updatedById,
      "AssignedToId": assignedToId,
      "DueDate": strDueDate
    };
  }
}
