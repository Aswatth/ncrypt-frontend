import 'package:Ncrypt/models/auto_backup_setting.dart';
import 'package:Ncrypt/models/password_generator_preference.dart';
import 'package:Ncrypt/utils/system.dart';
import 'package:Ncrypt/models/system_data.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class SystemDataClient {
  static final SystemDataClient _instance = SystemDataClient._internal();

  SystemDataClient._internal();

  SystemData? SYSTEM_DATA;

  late String jwtToken;

  factory SystemDataClient() {
    return _instance;
  }

  Future<dynamic> getGeneratedPassword() async {
    var url =
        Uri.http("localhost:${System().PORT}", "/system/generate_password");

    var response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }

  Future<dynamic> getSystemData() async {
    var url = Uri.http("localhost:${System().PORT}", "/system/data");

    var response = await http.get(url,
        headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      _instance.SYSTEM_DATA =
          SystemData.fromJson(convert.jsonDecode(response.body));
      return SYSTEM_DATA;
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }

  Future<dynamic> setup(
      String masterPassword, AutoBackupSetting autoBackupSetting) async {
    var url = Uri.http("localhost:${System().PORT}", "/system/setup");

    String jsonString = convert.jsonEncode({
      "master_password": masterPassword,
      "auto_backup_setting": autoBackupSetting
    });

    var response = await http.post(url, body: jsonString);

    if (response.statusCode == 200) {
      return "";
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }

  Future<String> signin(String password) async {
    var url = Uri.http("localhost:${System().PORT}", "/system/signin");

    String jsonString = convert.jsonEncode({"master_password": password});
    var response = await http.post(url, body: jsonString);

    if (response.statusCode == 200) {
      _instance.jwtToken = convert.jsonDecode(response.body) as String;
      return "";
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }

  Future<String> logout() async {
    var url = Uri.http("localhost:${System().PORT}", "/system/logout");

    var response = await http.post(url,
        headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      return "";
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }

  Future<dynamic> export(String path, String fileName) async {
    var url = Uri.http("localhost:${System().PORT}", "/system/export");

    String jsonString =
        convert.jsonEncode({"file_name": fileName, "path": path});
    var response = await http.post(url,
        body: jsonString,
        headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      return "";
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }

  Future<dynamic> import(String path, String fileName, String password) async {
    var url = Uri.http("localhost:${System().PORT}", "/system/import");

    String jsonString = convert.jsonEncode(
        {"file_name": fileName, "path": path, "master_password": password});
    var response = await http.post(url, body: jsonString);

    if (response.statusCode == 200) {
      return "";
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }

  Future<dynamic> backup() async {
    var url = Uri.http("localhost:${System().PORT}", "/system/backup");

    var response = await http.post(url,
        headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      return "";
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }

  Future<dynamic> updateAutomaticBackupData(
      AutoBackupSetting autoBackupSetting) async {
    var url = Uri.http(
        "localhost:${System().PORT}", "/system/automatic_backup_setting");

    String jsonString = convert.jsonEncode(autoBackupSetting.toJson());

    var response = await http.put(url,
        body: jsonString,
        headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      _instance.SYSTEM_DATA!.autoBackupSetting = autoBackupSetting;
      return "";
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }

  Future<dynamic> getPasswordGeneratorPreference() async {
    var url = Uri.http(
        "localhost:${System().PORT}", "/system/password_generator_preference");

    var response = await http.get(url,
        headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      return PasswordGeneratorPreference.fromJson(
          convert.jsonDecode(response.body));
    } else {
      var json = response.body;
      return json;
    }
  }

  Future<dynamic> updatePasswordGeneratorPreference(
      PasswordGeneratorPreference passwordGeneratorPreference) async {
    var url = Uri.http(
        "localhost:${System().PORT}", "/system/password_generator_preference");

    String requestBody =
        convert.jsonEncode(passwordGeneratorPreference.toJson());
    var response = await http.put(url,
        body: requestBody,
        headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      _instance.SYSTEM_DATA!.passwordGeneratorPreference = passwordGeneratorPreference;
      return "";
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }

  Future<dynamic> updateSessionTimeout(int sessionTimeoutInMinutes) async {
    var url =
        Uri.http("localhost:${System().PORT}", "/system/session_duration");

    String requestBody = convert
        .jsonEncode({"session_duration_in_minutes": sessionTimeoutInMinutes});

    var response = await http.put(url,
        body: requestBody,
        headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      _instance.SYSTEM_DATA!.sessionDurationInMinutes = sessionTimeoutInMinutes;
      _instance.jwtToken = convert.jsonDecode(response.body) as String;
      return null;
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }

  Future<dynamic> extendSession() async {
    var url =
        Uri.http("localhost:${System().PORT}", "/system/session_duration");

    var response = await http.get(url,
        headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      _instance.jwtToken = convert.jsonDecode(response.body) as String;
      return null;
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }

  Future<dynamic> updateTheme(String theme) async {
    var url = Uri.http("localhost:${System().PORT}", "/system/theme");

    String requestBody = convert.jsonEncode({"theme": theme});

    var response = await http.put(url,
        body: requestBody,
        headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      _instance.SYSTEM_DATA!.theme = theme;
      return null;
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }
}
