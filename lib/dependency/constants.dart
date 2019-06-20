import 'package:crm_app/model/Status.dart';
import 'package:crm_app/model/employee.dart';

String baseUrl = "https://addon365crm.azurewebsites.net/api";
bool isReleaseMode = true;

void setMode(bool bIsReleaseMode){
  isReleaseMode=bIsReleaseMode;
  if(isReleaseMode){
    baseUrl = "https://addon365crm.azurewebsites.net/api";
  }else{
    baseUrl = "http://192.168.0.101:3000/api";
  }
}

class Constants {
  static List<Status> statuses;
  static List<Employee> employees;
}
