import 'package:frontend/clients/env_loader.dart';
import 'package:frontend/models/login.dart';
import 'package:frontend/models/login_account.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class LoginDataClient {
  Future<dynamic> addLoginData(LoginData data) async {
    var url = Uri.http("localhost:${EnvLoader().PORT}", "/login");

    String jsonString = convert.jsonEncode(data.toJson());

    var response = await http.post(url, body: jsonString);

    if (response.statusCode == 200) {
      return "";
    } else {
      var json = convert.jsonDecode(response.body);
      return json;
    }
  }

  Future<dynamic> getAllLoginData() async {
    var url = Uri.http("localhost:${EnvLoader().PORT}", "/login");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      //Map decoded response to model object
      List<dynamic> jsonArray = convert.jsonDecode(response.body);

      List<LoginData> _loginDataList =
          jsonArray.map((json) => LoginData.fromJson(json)).toList();

      return _loginDataList;
    } else {
      var json = convert.jsonDecode(response.body);
      return json;
    }
  }

  Future<dynamic> deleteLoginData(String loginDataName) async {
    var url =
        Uri.http("localhost:${EnvLoader().PORT}", "/login/$loginDataName");

    var response = await http.delete(url);

    if (response.statusCode == 200) {
      return "";
    } else {
      var json = convert.jsonDecode(response.body);
      return json;
    }
  }
}
