import 'package:crm_app/model/Status.dart';
import 'package:crm_app/model/user.dart';

class AppointmentStatus {
  String id;
  String comments;
  User assignedTo;
  User updatedBy;
  Status status;

  AppointmentStatus(
      {this.id, this.comments, this.assignedTo, this.updatedBy, this.status});

  static List<AppointmentStatus> fromJsonArray(
      List<Map<String, dynamic>> mapList) {
    List<AppointmentStatus> statuses = new List<AppointmentStatus>();
    mapList.forEach((map) {
      statuses.add(AppointmentStatus.fromJson(map));
    });
    return statuses;
  }

  static AppointmentStatus fromJson(Map<String, dynamic> map) {
    return AppointmentStatus(
        id: map['id'],
        comments: map['comments'],
        assignedTo: User.fromJson(map['assignedTo']),
        updatedBy: User.fromJson(map['updatedBy']),
        status: Status.fromJson(map['status']));
  }

  void copyFrom(AppointmentStatus appointmentStatus) {
    assignedTo=appointmentStatus.assignedTo;
    updatedBy=appointmentStatus.updatedBy;
    status=appointmentStatus.status;
  }
}
