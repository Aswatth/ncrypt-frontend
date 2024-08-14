import 'package:frontend/clients/env_loader.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'package:frontend/models/login.dart';
import 'package:frontend/models/login_account.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class LoginDataClient {
  Future<dynamic> addLoginData(LoginData data) async {
    var url = Uri.http("localhost:${EnvLoader().PORT}", "/login");

    String jsonString = convert.jsonEncode(data.toJson());

    var response = await http.post(url, body: jsonString,headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      return "";
    } else {
      var json = convert.jsonDecode(response.body);
      return json;
    }
  }

  Future<dynamic> getAllLoginData() async {
    var url = Uri.http("localhost:${EnvLoader().PORT}", "/login");

    var response = await http.get(url,headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      var data = convert.jsonDecode(response.body);
      List<dynamic> jsonArray = data == null ? [] : data;

      List<LoginData> _loginDataList =
          jsonArray.map((json) => LoginData.fromJson(json)).toList();

      return _loginDataList;
    } else {
      var json = convert.jsonDecode(response.body);
      return json;
    }
  }

  Future<dynamic> updateLoginData(String name, LoginData data) async {
    var url = Uri.http("localhost:${EnvLoader().PORT}", "/login/${name}");

    String jsonString = convert.jsonEncode(data.toJson());

    var response = await http.put(url, body: jsonString);

    if (response.statusCode == 200) {
      return "";
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

  Future<dynamic> getDecryptedPassword(String name, String username) async {
    var url = Uri.http("localhost:${EnvLoader().PORT}", "/login/$name", {"username": username});

    var response = await http.get(url, headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body) as String;
    } else {
      var json = convert.jsonDecode(response.body);
      return json;
    }
  }
}
