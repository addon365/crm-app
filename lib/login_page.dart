import 'package:crm_app/admin_pages/admin_home_page.dart';
import 'package:crm_app/marketing_pages/marketing_home_page.dart';
import 'package:crm_app/model/user.dart';
import 'package:crm_app/repository/user_repository.dart';
import 'package:crm_app/tele_pages/campaign_list_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dependency/constants.dart';



class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userIdController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final UserRepository userRepository = new UserRepository();
  bool _loading = false;
  final mainKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool _loggedIn = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool get loggedIn => _loggedIn;

  set loggedIn(bool logIn) {
    setState(() {
      _loggedIn = logIn;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  set loading(bool value) {
    setState(() {
      _loading = value;
    });
  }

  void doLogin() {
    var form = formKey.currentState;

    final userName = userIdController.text;
    final password = passwordController.text;
    if (form.validate()) {
      loading = true;
      userRepository.validateUser(userName, password).then((user) {
        loading = false;
        currentUser = user;

        navigateToPage(user);
      }, onError: (error) {
        final snackBar = SnackBar(content: Text(error.toString()));
        this.mainKey.currentState.showSnackBar(snackBar);
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: mainKey,
        appBar: AppBar(
          title: Text("Login"),
          leading: Text(""),
        ),
        body: Stack(
          children: <Widget>[
            Center(child: _loading ? CircularProgressIndicator() : Text("")),
            new Form(
              key: formKey,
              child: new Center(
                  child: new ListView(
                      padding: EdgeInsets.all(5),
                      children: <Widget>[
                    Image.asset(
                      "assets/splash.png",
                      height: 200,
                      width: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Center(
                          child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      )),
                    ),
                    TextFormField(
                        decoration: new InputDecoration(
                            labelText: "User Id",
                            icon: Icon(
                              Icons.face,
                              color: Theme.of(context).accentColor,
                            )),
                        controller: userIdController,
                        validator: (val) {
                          if (val.length == 0) {
                            return "user id cannot be empty";
                          }
                          return null;
                        },
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text),
                    TextFormField(
                        controller: passwordController,
                        decoration: new InputDecoration(
                            labelText: "Password",
                            icon: Icon(
                              FontAwesomeIcons.key,
                              color: Theme.of(context).accentColor,
                            )),
                        obscureText: true,
                        validator: (val) {
                          if (val.length == 0) {
                            return "Password cannot be empty.";
                          } else {
                            return null;
                          }
                        },
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text),
                    RaisedButton(
                      onPressed: _loading ? null : doLogin,
                      child: Text("Login"),
                      color: Theme.of(context).primaryColor,
                    ),
                  ])),
            ),
          ],
        ));
  }

  void updateFirebaseToken() {
    if (currentUser.token != null) return;
    _firebaseMessaging.getToken().then((token) {
      try {
        if (token == null) return;
        Constants.token = token;
      } catch (exception) {
        print(exception);
      }
    });
  }

  void navigateToPage(User user) {
    String routeName;
    switch (user.roleGroup.name) {
      case "marketing":
        routeName = MarketingHomePage.routeName;
        break;
      case "admin":
        routeName = AdminHomePage.routeName;
        break;
      case "tele":
        routeName = CampaignListPage.routeName;
        break;
    }
    Navigator.pushReplacementNamed(context, routeName);
  }
}
