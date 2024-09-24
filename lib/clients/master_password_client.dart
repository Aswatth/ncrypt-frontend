import 'package:frontend/utils/system.dart';
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
    var url = Uri.http("localhost:${System().PORT}", "/master_password");

    String jsonString = convert.jsonEncode({"master_password": password});

    var response = await http.post(url,body: jsonString, headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      return "";
    } else {
      if(response.statusCode == 401) {
        return setMasterPassword(password);
      } else {
        var json = convert.jsonDecode(response.body) as String;
        return json;
      }

    }
  }

  Future<String> updateMasterPassword(String oldMasterPassword, String newMasterPassword) async {
    var url = Uri.http("localhost:${System().PORT}", "/master_password");

    String jsonString = convert.jsonEncode({"old_master_password": oldMasterPassword, "new_master_password": newMasterPassword});
    var response = await http.put(url,body: jsonString, headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      return "";
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }

  Future<String> validateMasterPassword(String password) async {
    var url = Uri.http("localhost:${System().PORT}", "/master_password/validate");

    String jsonString = convert.jsonEncode({"master_password": password});

    var response = await http.post(url,body: jsonString, headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      return "true";
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }
}
