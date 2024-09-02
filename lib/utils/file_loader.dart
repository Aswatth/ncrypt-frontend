import 'package:file_picker/file_picker.dart';

class FileUtils {
  static final FileUtils _instance = FileUtils._internal();

  FileUtils._internal();

  factory FileUtils() {
    return _instance;
  }

  Future<String?> pickFolder() async {
     String? result = await FilePicker.platform.getDirectoryPath();
     return result;
  }
}