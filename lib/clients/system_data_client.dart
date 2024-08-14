import 'package:frontend/clients/env_loader.dart';
import 'package:frontend/models/system_data.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class SystemDataClient {
  static final SystemDataClient _instance = SystemDataClient._internal();

  SystemDataClient._internal();

  late SystemData SYSTEM_DATA;

  late String jwtToken;

  factory SystemDataClient () {
    return _instance;
  }

  Future<dynamic> getSystemData() async {

    var url = Uri.http("localhost:${EnvLoader().PORT}", "/system/login_info");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      _instance.SYSTEM_DATA = SystemData.fromJson(convert.jsonDecode(response.body));
      return SYSTEM_DATA;
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }

  Future<String> login(String password) async {
    var url = Uri.http("localhost:${EnvLoader().PORT}", "/system/login");

    String jsonString = convert.jsonEncode({"master_password": password});
    var response = await http.post(url,body: jsonString);

    if (response.statusCode == 200) {
      _instance.jwtToken = convert.jsonDecode(response.body) as String;
      return "";
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }

  Future<dynamic> export(String path, String fileName) async {
    var url = Uri.http("localhost:${EnvLoader().PORT}", "/system/export");

    String jsonString = convert.jsonEncode({"file_name": fileName, "path": path});
    var response = await http.post(url, body: jsonString,headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      return "";
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }

  Future<dynamic> import(String path, String fileName, String password) async {
    var url = Uri.http("localhost:${EnvLoader().PORT}", "/system/import");

    String jsonString = convert.jsonEncode({"file_name": fileName, "path": path, "master_password": password});
    var response = await http.post(url, body: jsonString);

    if (response.statusCode == 200) {
      return "";
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }
}
