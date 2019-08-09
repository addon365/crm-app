import 'package:crm_app/edit_appointment_page.dart';
import 'package:crm_app/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dependency/constants.dart';
import 'model/appointment_view_model.dart';

void main() {
  setMode(kReleaseMode);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _fireBaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    configureFireBase();
  }

  void configureFireBase() {
    _fireBaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print(message);
      return null;
    }, onLaunch: (message) {
      print("OnLaunch $message");
      return null;
    }, onResume: (message) {
      print("OnResume $message");
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Addon CRM',
      theme: new ThemeData(
          fontFamily: 'Ubuntu',
          brightness: Brightness.light,
          primarySwatch: Colors.red,
          accentColor: Colors.black),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case EditAppointmentPage.routeName:
            return MaterialPageRoute(builder: (BuildContext context) {
              final AppointmentViewModel appointment = settings.arguments;
              return EditAppointmentPage(appointment);
            });
            break;
        }

        return null;
      },
      routes: routes,
    );
  }
}
