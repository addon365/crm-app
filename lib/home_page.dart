import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/login_page.dart';
import 'package:crm_app/model/appointment-status.dart';
import 'package:crm_app/model/appointment.dart';
import 'package:crm_app/repository/appointment_repository.dart';
import 'package:crm_app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    });
    onRefresh();
  }

  Future<void> onRefresh() {
    repository.fetchAppointments().then((appointments) {
      setState(() {
        this.appointments = appointments;
      });
    });
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
          child: appointments == null
              ? Center(
                  child: InkWell(
                      onTap: onRefresh, child: Text("No appointments found.")))
              : ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    Appointment appointment = appointments[index];
                    AppointmentStatus status =
                        appointment.statuses[appointment.statuses.length - 1];
                    return ExpansionTile(
                      title: Text(appointment.customer.user.userName),
                      leading: _buildLeading(status),
                      children: <Widget>[
                        Text(status.comments),
                        ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {},
                              child: Text("Edit"),
                              textColor: Theme.of(context).primaryColor,
                            )
                          ],
                        )
                      ],
                    );
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
