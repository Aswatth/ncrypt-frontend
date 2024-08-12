import 'package:frontend/clients/env_loader.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class MasterPasswordClient {
  static final MasterPasswordClient _instance = MasterPasswordClient._internal();

  MasterPasswordClient._internal();

  factory MasterPasswordClient () {
    return _instance;
  }

  Future<String> setMasterPassword(String password) async {
    var url = Uri.http("localhost:${EnvLoader().PORT}", "/master_password");

    String jsonString = convert.jsonEncode({"master_password": password});

    var response = await http.post(url,body: jsonString, headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      return "";
    } else {
      if(response.statusCode == 401) {
        //regenerate temporary token if older token is expired.
        await SystemDataClient().login("");
        print("regenerating token");
        return setMasterPassword(password);
      } else {
        var json = convert.jsonDecode(response.body) as String;
        return json;
      }

    }
  }

  Future<String> updateMasterPassword(String password) async {
    var url = Uri.http("localhost:${EnvLoader().PORT}", "/master_password");

    String jsonString = convert.jsonEncode({"master_password": password});
    var response = await http.put(url,body: jsonString);

    if (response.statusCode == 200) {
      return "";
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }
}
