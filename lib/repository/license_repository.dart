import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crm_app/dependency/constants.dart';

class LicenseRepository {
  static LicenseRepository leadRepository;

  static LicenseRepository getRepository() {
    if (leadRepository == null) leadRepository = new LicenseRepository();
    return leadRepository;
  }

  Future<bool> generateLicense() async {
    String url = '$baseUrl/svb/v1.0/license/Create';
    Map<String, dynamic> userIdJsonMap = new Map<String, dynamic>();
    userIdJsonMap.putIfAbsent("CustomerCatalogGroupId", () => currentUser.id);

    print(userIdJsonMap);
    String licenseGenerationJson = json.encode(userIdJsonMap);
    print(licenseGenerationJson);
    var result = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: licenseGenerationJson);
    if (result.statusCode == 200) {
      return true;
    } else {
      var map = json.decode(result.body);
      print(map);
      return false;
    }
  }
}
