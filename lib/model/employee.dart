import 'package:crm_app/model/user.dart';

class Employee {
  String id;
  User user;

  Employee({this.id, this.user});

  static Employee fromJson(Map<String, dynamic> map) {
    return Employee(id: map['id'], user: User.fromJson(map['user']));
  }

  static List<Employee> fromJsonArray(List<Map<String, dynamic>> mapList) {
    List<Employee> employees = new List();
    mapList.forEach((customerMap) {
      employees.add(Employee.fromJson(customerMap));
    });
    return employees;
  }
}
