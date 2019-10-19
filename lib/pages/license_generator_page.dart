import 'package:crm_app/db/widget/app-drawer-widget.dart';
import 'package:crm_app/repository/license_repository.dart';
import 'package:flutter/material.dart';

class LicenseGeneratorPage extends StatefulWidget {
  static const routeName = "/license-key-generator-page";

  @override
  _LicenseGeneratorPageState createState() => _LicenseGeneratorPageState();
}

class _LicenseGeneratorPageState extends State<LicenseGeneratorPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: Scaffold(
          key: _scaffoldKey,
          drawer: AppDrawerWidget(),
          appBar: AppBar(
            title: Text("License Key Generator"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "License key will be generated and sent to your mail id. License key is unique and confidential so don't share it any one",
                  style: TextStyle(fontSize: 24),
                  softWrap: true,
                ),
                Container(
                  height: 30,
                ),
                Text(
                  "உரிம விசை உருவாக்கப்பட்டு உங்கள் மெயிலுக்கு அனுப்பப்படும். உரிம விசை தனித்துவமானது மற்றும் ரகசியமானது, எனவே இதை யாருக்கும் பகிர வேண்டாம்",
                  style: TextStyle(fontSize: 20),
                  softWrap: true,
                ),
                Container(
                  height: 30,
                ),
                SizedBox(
                  height: 60,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      generateLicense(context);
                    },
                    child: Text("Generate License Key"),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void generateLicense(BuildContext context) {
    LicenseRepository.getRepository().generateLicense().then((onValue)  {
      print("Success :$onValue");
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: Text(
                  'License Key Generation request submitted successfull, check your mail.')));
        });
  }
}
