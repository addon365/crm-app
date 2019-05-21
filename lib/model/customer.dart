import 'package:crm_app/model/user.dart';

class Customer {
  String id;
  User user;

  Customer({this.id, this.user});

  static Customer fromJson(Map<String, dynamic> map) {
    return Customer(id: map['id'], user: User.fromJson(map['user']));
  }

  static List<Customer> fromJsonArray(List<Map<String, dynamic>> mapList) {
    List<Customer> customers = new List();
    mapList.forEach((customerMap) {
      customers.add(Customer.fromJson(customerMap));
    });
    return customers;
  }
}
