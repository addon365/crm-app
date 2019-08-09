import 'dart:convert';

import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/model/campaign.dart';
import 'package:crm_app/model/view/campaign_view_model.dart';
import 'package:http/http.dart' as http;

class CampaignRepository {
  static CampaignRepository campaignRepository;

  static CampaignRepository getRepository() {
    if (campaignRepository == null)
      campaignRepository = new CampaignRepository();
    return campaignRepository;
  }

  Future<List<CampaignViewModel>> fetchCampaigns() async {
    String url = '$baseUrl/campaign/listvm';
    var result = await http.get(url);
    if (result.statusCode == 200) {
      var mapList = List<Map<String, dynamic>>.from(json.decode(result.body));
      return CampaignViewModel.fromJsonArray(mapList);
    } else {
      return null;
    }
  }

  Future<Campaign> fetchCampaign(String id) async {
    String url = '$baseUrl/campaign/info';
    var result = await http.get(url);
    if (result.statusCode == 200) {
      return Campaign.fromJson(json.decode(result.body));
    } else {
      return null;
    }
  }
}
