import 'dart:convert';

import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/model/status.dart';
import 'package:http/http.dart' as http;

class StatusRepository {
  static StatusRepository repository;

  static StatusRepository getRepository() {
    if (repository == null) {
      repository = new StatusRepository();
    }
    return repository;
  }
  Future<List<Status>> fetchStatuses() async {
    String url = '$baseUrl/StatusesMaster';
    var result = await http.get(url);
    if (result.statusCode == 200) {
      var mapList = List<Map<String, dynamic>>.from(json.decode(result.body));
      return Status.fromJsonArray(mapList);
    } else {
      return null;
    }
  }

  Status findById(String id){
    return Constants.statuses.where((Status s)=> s.id==id).first;
  }
}
