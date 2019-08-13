import 'dart:convert';

import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/model/campaign.dart';
import 'package:crm_app/model/view/campaign_info_view_model.dart';
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

  Future<List<CampaignInfoViewModel>> fetchCampaignInfos(String id) async {
    String url = '$baseUrl/campaign/infos?campaignId=$id';
    var result = await http.get(url);
    if (result.statusCode == 200) {
      var mapList = List<Map<String, dynamic>>.from(json.decode(result.body));
      return CampaignInfoViewModel.fromJsonArray(mapList);
    } else {
      return null;
    }
  }

  /*
   * Returns the single campaignInfo by it's campaignInfo Id,
   * Lead object can be retrieved from this campaignInfo
   */
  Future<CampaignInfo> fetchCampaignInfo(String campaignInfoId) async {
    String url = '$baseUrl/campaign/info?campaignInfoId=$campaignInfoId';
    var result = await http.get(url);
    if (result.statusCode == 200) {
      
      return CampaignInfo.fromJson(json.decode(result.body));
    } else {
      return null;
    }
  }
}
