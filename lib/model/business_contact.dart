import 'contact.dart';

class BusinessContact {
  String businessName;
  Contact proprietor;
  Contact contactPerson;

  BusinessContact({this.businessName, this.proprietor, this.contactPerson});

  factory BusinessContact.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return BusinessContact(
        businessName: json['businessName'],
        proprietor: Contact.fromJson(json['proprietor']),
        contactPerson: Contact.fromJson(json['contactPerson']));
  }
}
