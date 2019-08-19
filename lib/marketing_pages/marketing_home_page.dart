import 'dart:io';

import 'package:crm_app/db/widget/app-drawer-widget.dart';
import 'package:crm_app/dependency/constants.dart';


import 'package:crm_app/marketing_pages/edit_appointment_page.dart';
import 'package:crm_app/model/appointment_view_model.dart';
import 'package:crm_app/repository/appointment_repository.dart';
import 'package:crm_app/repository/status_repository.dart';
import 'package:crm_app/repository/user_repository.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MarketingHomePage extends StatefulWidget {
  static const String routeName = '/marketing-home';

  @override
  _MarketingHomePageState createState() => _MarketingHomePageState();
}

class _MarketingHomePageState extends State<MarketingHomePage> {
  List<AppointmentViewModel> appointments;
  AppointmentRepository repository;
  StatusRepository statusRepository;

  @override
  void initState() {
    super.initState();

    init();

    fetchNecessary();

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

  Future<bool> _onWillPop(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        drawer: AppDrawerWidget(),
        appBar: AppBar(
          title: Text("Appointments"),
        ),
        body: RefreshIndicator(
            child: appointments == null || appointments.length == 0
                ? Center(
                    child: InkWell(
                        onTap: onRefresh,
                        child: Text("No appointments for you.")))
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
      ),
      onWillPop: () {
        return _onWillPop(context);
      },
    );
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

  void init() {
    repository = AppointmentRepository.getRepository();
    statusRepository = StatusRepository.getRepository();
  }

  void fetchNecessary() {
    statusRepository.fetchStatuses().then((statuses) {
      Constants.statuses = statuses;
    });
  }

  void updateToken() {
    UserRepository.getRepository().updateToken(Constants.token);
  }
}
