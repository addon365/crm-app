import 'business_contact.dart';
import 'lead_history.dart';

class Lead {
  String id;
  BusinessContact businessContact;

  List<LeadHistory> history;

  Lead({this.id, this.businessContact, this.history});

  static Lead fromJson(Map<String, dynamic> map) {
    List<Map<String, dynamic>> history =
        List<Map<String, dynamic>>.from(map['history']);

    return Lead(
        id: map['id'],
        businessContact: BusinessContact.fromJson(map['contact']),
        history: LeadHistory.fromJsonArray(history));
  }

  static List<Lead> fromJsonArray(List<Map<String, dynamic>> mapList) {
    List<Lead> customers = new List();
    mapList.forEach((customerMap) {
      customers.add(Lead.fromJson(customerMap));
    });
    return customers;
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> historyMap = new List<Map<String, dynamic>>();
    for (LeadHistory aHistory in history) {
      historyMap.add(aHistory.toJson());
    }
    return {"id": id, "history": historyMap};
  }
}
