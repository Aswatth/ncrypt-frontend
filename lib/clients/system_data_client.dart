import 'package:frontend/clients/env_loader.dart';
import 'package:frontend/models/system_data.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class SystemDataClient {
  Future<dynamic> getSystemData() async {

    var url = Uri.http("localhost:${EnvLoader().PORT}", "/system/login_info");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      SystemData systemData = SystemData.fromJson(convert.jsonDecode(response.body));
      return systemData.loginCount;
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }
}
