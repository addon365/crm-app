import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/login_page.dart';
import 'package:crm_app/model/appointment-status.dart';
import 'package:crm_app/model/appointment.dart';
import 'package:crm_app/repository/appointment_repository.dart';
import 'package:crm_app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'edit_appointment_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Appointment> appointments;
  AppointmentRepository repository;

  @override
  void initState() {
    super.initState();
    repository = AppointmentRepository.getRepository();

    repository.fetchStatuses().then((statuses) {
      Constants.statuses = statuses;
      print(Constants.statuses);
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
                    Appointment appointment = appointments[index];
                    AppointmentStatus status = appointment.currentStatus;
                    return ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                              context, EditAppointmentPage.routeName,
                              arguments: appointment);
                        },
                        title: Text(appointment.lead.user.userName),
                        subtitle: Text(
                            status.comments != null ? status.comments : ""),
                        leading: _buildLeading(status),
                        trailing: Icon(Icons.keyboard_arrow_right));
                  }),
          onRefresh: onRefresh),
    );
  }

  void signOut() {
    new UserRepository().logout();
    Navigator.popAndPushNamed(context, LoginPage.routeName);
  }

  Widget _buildLeading(AppointmentStatus status) {
    if (status.status.name == "Open") {
      return CircleAvatar(
        child: Icon(FontAwesomeIcons.bookOpen),
      );
    } else {
      return CircleAvatar(child: Icon(FontAwesomeIcons.checkDouble));
    }
  }
}
