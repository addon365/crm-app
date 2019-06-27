import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/login_page.dart';
import 'package:crm_app/repository/appointment_repository.dart';
import 'package:crm_app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'edit_appointment_page.dart';
import 'model/appointment-view-model.dart';
import 'repository/status_repository.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AppointmentViewModel> appointments;
  AppointmentRepository repository;
  StatusRepository statusRepository;

  @override
  void initState() {
    super.initState();
    repository = AppointmentRepository.getRepository();
    statusRepository = StatusRepository.getRepository();
    statusRepository.fetchStatuses().then((statuses) {
      Constants.statuses = statuses;
    });

    onRefresh();
  }

  Future<bool> onRefresh() {
    repository.fetchAppointments().then((appointments) {
      setState(() {
        this.appointments = appointments;
        print(this.appointments);
      });
    });
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(""),
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.signOutAlt),
              onPressed: () {
                signOut();
              }),
        ],
      ),
      body: RefreshIndicator(
          child: appointments == null || appointments.length == 0
              ? Center(
                  child: InkWell(
                      onTap: onRefresh, child: Text("No appointments found.")))
              : ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    AppointmentViewModel appointment = appointments[index];
                    return ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                              context, EditAppointmentPage.routeName,
                              arguments: appointment);
                        },
                        title: Text(appointment.leadName),
                        subtitle: Text(appointment.comments != null
                            ? appointment.comments
                            : ""),
                        leading: _buildLeading(appointment),
                        trailing: Icon(Icons.keyboard_arrow_right));
                  }),
          onRefresh: onRefresh),
    );
  }

  void signOut() {
    new UserRepository().logout();
    Navigator.popAndPushNamed(context, LoginPage.routeName);
  }

  Widget _buildLeading(AppointmentViewModel appointment) {
    switch (appointment.status) {
      case "Open":
        return CircleAvatar(
          child: Icon(FontAwesomeIcons.bookOpen),
        );
      case "InProgress":
        return CircleAvatar(child: Icon(FontAwesomeIcons.spinner));
      case "Closed":
        return CircleAvatar(child: Icon(FontAwesomeIcons.checkDouble));
      default:
        return CircleAvatar(child: Icon(FontAwesomeIcons.checkDouble));
    }
  }
}
