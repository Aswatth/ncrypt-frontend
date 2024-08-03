import 'dart:io';

class EnvLoader {
  static final EnvLoader _instance = EnvLoader._internal();

  EnvLoader._internal();

  late final int PORT;

  Future<void> load (String filePath) async {
    final envFile = File(filePath);
    final envContent = await envFile.readAsString();
    PORT = int.parse(_parseEnvContent(envContent)["PORT"]!);
  }

  Map<String, String> _parseEnvContent(String content) {
    final envMap = <String, String>{};
    final lines = content.split('\n');
    for (var line in lines) {
      final keyValue = line.split('=');
      if (keyValue.length == 2) {
        envMap[keyValue[0].trim()] = keyValue[1].trim();
      }
    }
    return envMap;
  }

  factory EnvLoader () {
    return _instance;
  }
}