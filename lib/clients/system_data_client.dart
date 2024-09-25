import 'package:frontend/models/password_generator_preference.dart';
import 'package:frontend/utils/system.dart';
import 'package:frontend/models/system_data.dart';
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

  Future<dynamic> setup(String password, bool automaticBackup,
      String backupFolderPath, String backupFileName) async {
    var url = Uri.http("localhost:${System().PORT}", "/system/setup");

    String jsonString = convert.jsonEncode({
      "master_password": password,
      "automatic_backup": automaticBackup,
      "backup_folder_path": backupFolderPath,
      "backup_file_name": backupFileName
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

  Future<dynamic> updateAutomaticBackupData(bool automaticBackup,
      String backupFolderPath, String backupFileName) async {
    var url = Uri.http(
        "localhost:${System().PORT}", "/system/automatic_backup_setting");

    String jsonString = convert.jsonEncode({
      "automatic_backup": automaticBackup,
      "backup_folder_path": backupFolderPath,
      "backup_file_name": backupFileName
    });

    var response = await http.put(url,
        body: jsonString,
        headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
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
      return "";
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }

  Future<dynamic> updateSessionTimeout(int sessionTimeoutInMinutes) async {
    var url = Uri.http("localhost:${System().PORT}", "/system/session_duration");

    String requestBody = convert
        .jsonEncode({"session_duration_in_minutes": sessionTimeoutInMinutes});

    var response = await http.put(url,
        body: requestBody,
        headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"});

    if (response.statusCode == 200) {
      _instance.jwtToken = convert.jsonDecode(response.body) as String;
      return null;
    } else {
      var json = convert.jsonDecode(response.body) as String;
      return json;
    }
  }
}
