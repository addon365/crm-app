import 'package:crm_app/model/user.dart';

class Customer {
  String id;
  User user;

  Customer({this.id, this.user});

  static Customer fromJson(Map<String, dynamic> map) {
    return Customer(id: map['id'], user: User.fromJson(map['user']));
  }
}
