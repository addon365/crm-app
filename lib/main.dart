import 'package:crm_app/edit_appointment_page.dart';
import 'package:crm_app/model/appointment.dart';
import 'package:crm_app/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'dependency/constants.dart';
import 'model/appointment-view-model.dart';
void main() {

    setMode(kReleaseMode);

  runApp(MyApp());}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
          fontFamily: 'Ubuntu',
          brightness: Brightness.light,
          primarySwatch: Colors.red,
          accentColor: Colors.black),
      onGenerateRoute: (settings) {
        if (settings.name == EditAppointmentPage.routeName) {

          return MaterialPageRoute(builder: (BuildContext context) {
            final AppointmentViewModel appointment = settings.arguments;
            return EditAppointmentPage(appointment);
          });
        }
      },
      routes: routes,
    );
  }
}
