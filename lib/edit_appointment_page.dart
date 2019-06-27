import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/employee_list_page.dart';
import 'package:crm_app/model/Status.dart';
import 'package:crm_app/model/appointment-status.dart';
import 'package:crm_app/model/appointment.dart';
import 'package:crm_app/repository/appointment_repository.dart';
import 'package:crm_app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'model/appointment-view-model.dart';
import 'model/user.dart';
import 'repository/status_repository.dart';

class EditAppointmentPage extends StatefulWidget {
  static const routeName = "/edit-appointment";
  AppointmentViewModel viewModel;


  EditAppointmentPage(AppointmentViewModel viewModel) {

    this.viewModel=viewModel;

  }

  @override
  _EditAppointmentPageState createState() => _EditAppointmentPageState();
}

class _EditAppointmentPageState extends State<EditAppointmentPage> {
  StatusRepository statusRepository;

  Status selectedStatus;
  User selectedUser;
  final TextEditingController controller = new TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  AppointmentViewModel viewModel;
  @override
  void initState() {
    super.initState();
    statusRepository=StatusRepository.getRepository();
    viewModel=this.widget.viewModel;

    selectedUser=new User(
      id: viewModel.assignedToId,
      userName: viewModel.assignedTo
    );
    selectedStatus=statusRepository.findById(viewModel.statusId);
    AppointmentRepository.getRepository().fetchEmployees().then((employees) {
      Constants.employees = employees;
    });
  }

  @override
  Widget build(BuildContext context) {

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
              title: Text(selectedUser.userName,
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
        selectedUser=result;
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
    viewModel.statusId=selectedStatus.id;
    viewModel.comments=controller.text;
    viewModel.assignedToId=selectedUser.id;

    AppointmentRepository.getRepository()
        .putAppointment(viewModel)
        .then((result) {
      if (result != null) {
        scaffoldKey.currentState
            .showSnackBar(new SnackBar(content: Text(result)));
      } else {
        Navigator.pop(context);
      }
    }).catchError((onError) {
      print(onError);
    });
  }
}
