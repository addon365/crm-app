import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/employee_list_page.dart';
import 'package:crm_app/model/Status.dart';
import 'package:crm_app/model/appointment-status.dart';
import 'package:crm_app/model/appointment.dart';
import 'package:crm_app/repository/appointment_repository.dart';
import 'package:crm_app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditAppointmentPage extends StatefulWidget {
  static const routeName = "/edit-appointment";
  Appointment appointment;

  EditAppointmentPage(Appointment appointment) {
    this.appointment = appointment;
  }

  @override
  _EditAppointmentPageState createState() => _EditAppointmentPageState();
}

class _EditAppointmentPageState extends State<EditAppointmentPage> {
  Status selectedStatus;
  final TextEditingController controller = new TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    AppointmentStatus appointmentStatus = new AppointmentStatus();
    appointmentStatus.copyFrom(this.widget.appointment.currentStatus);
    this.widget.appointment.currentStatus = appointmentStatus;
    selectedStatus = this.widget.appointment.currentStatus.status;
    AppointmentRepository.getRepository().fetchEmployees().then((employees) {
      Constants.employees = employees;
    });
  }

  @override
  Widget build(BuildContext context) {
    Appointment appointment = this.widget.appointment;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Edit Appointment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(appointment.currentStatus.assignedTo.userName,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Icon(FontAwesomeIcons.chevronRight),
              onTap: chooseCustomer,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Appointment Status",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<Status>(
                  value: selectedStatus,
                  items: Constants.statuses
                      .map<DropdownMenuItem<Status>>((status) {
                    return DropdownMenuItem<Status>(
                        value: status, child: Text(status.name));
                  }).toList(),
                  onChanged: (Status status) {
                    setState(() {
                      selectedStatus = status;
                    });
                  },
                ),
              ],
            ),
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: "Comments"),
              maxLines: 3,
              minLines: 1,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: save,
                    child: Text("Save"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void chooseCustomer() async {
    var result = await Navigator.pushNamed(context, EmployeeListPage.routeName);
    if (result != null) {
      setState(() {
        this.widget.appointment.currentStatus.assignedTo = result;
      });
    }
  }

  void save() {
    if (controller.text == null || controller.text.length < 4) {
      SnackBar snackbar = new SnackBar(
        content: Text("Please update comments"),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);
      return;
    }
    Appointment appointment = this.widget.appointment;
    appointment.currentStatus.comments = controller.text;
    appointment.currentStatus.updatedBy = UserRepository.currentUser;
    appointment.currentStatus.status = selectedStatus;
    AppointmentRepository.getRepository()
        .putAppointment(this.widget.appointment)
        .then((result) {
      Navigator.pop(context);
    }).catchError((onError) {
      print(onError);
    });
  }
}
