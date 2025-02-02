import 'package:Ncrypt/utils/system.dart';
import 'package:Ncrypt/clients/system_data_client.dart';
import 'package:Ncrypt/models/login.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class LoginDataClient {
  static final LoginDataClient _instance = LoginDataClient._internal();

  LoginDataClient._internal();

  factory LoginDataClient() {
    return _instance;
  }

  Future<dynamic> addLoginData(LoginData data) async {
    var url = Uri.http("localhost:${System().PORT}", "/login");

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
    var url = Uri.http("localhost:${System().PORT}", "/login");

    var response = await http.get(url,headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      var data = convert.jsonDecode(response.body);

      if(data == null) {
        return null;
      }
      List<dynamic> loginDataList =
      data.map((json) => LoginData.fromJson(json)).toList();

      return loginDataList;
    } else {
      var json = convert.jsonDecode(response.body);
      return json;
    }
  }

  Future<dynamic> updateLoginData(String name, LoginData data) async {
    var url = Uri.http("localhost:${System().PORT}", "/login/${name}");

    String jsonString = convert.jsonEncode(data.toJson());

    var response = await http.put(url, body: jsonString,headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      return "";
    } else {
      var json = convert.jsonDecode(response.body);
      return json;
    }
  }

  Future<dynamic> deleteLoginData(String loginDataName) async {
    var url =
        Uri.http("localhost:${System().PORT}", "/login/$loginDataName");

    var response = await http.delete(url,headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      return "";
    } else {
      var json = convert.jsonDecode(response.body);
      return json;
    }
  }

  Future<dynamic> getDecryptedPassword(String name, String username) async {
    var url = Uri.http("localhost:${System().PORT}", "/login/$name", {"username": username});

    var response = await http.get(url, headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body) as String;
    } else {
      var json = convert.jsonDecode(response.body);
      return json;
    }
  }
}
