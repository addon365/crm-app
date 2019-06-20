import 'user.dart';

class Lead {
  String id;
  User user;

  Lead({this.id, this.user});

  static Lead fromJson(Map<String, dynamic> map) {
    return Lead(id: map['id'], user: User.fromJson(map['user']));
  }

  static List<Lead> fromJsonArray(List<Map<String, dynamic>> mapList) {
    List<Lead> customers = new List();
    mapList.forEach((customerMap) {
      customers.add(Lead.fromJson(customerMap));
    });
    return customers;
  }
}
