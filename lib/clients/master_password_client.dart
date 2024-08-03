import 'package:frontend/clients/env_loader.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class MasterPasswordClient {
  Future<String> setMasterPassword(String password) async {
    var url = Uri.http("localhost:${EnvLoader().PORT}", "/master_password");

    String jsonString = convert.jsonEncode({"master_password": password});
    var response = await http.post(url,body: jsonString);

    if (response.statusCode == 200) {
      return "";
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }

  Future<String> login(String password) async {
    var url = Uri.http("localhost:${EnvLoader().PORT}", "/master_password/validate");

    String jsonString = convert.jsonEncode({"master_password": password, "is_login": "true"});
    var response = await http.post(url,body: jsonString);

    if (response.statusCode == 200) {
      return "";
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }
}
