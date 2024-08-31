import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'package:frontend/custom_toast/custom_toast.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({super.key});

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  String _selectedLocation = "";

  void pickDirectory() {
    FilePicker.platform.getDirectoryPath().then((value) {
      if (value != null) {
        setState(() {
          _selectedLocation = value;
        });
      }
    });
  }

  void saveFile() {
    FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'backup.ncrypt',
        allowedExtensions: ['ncrypt']).then((value) {
      if (value != null) {
        List<String> splitString = value.split("\\");

        String fileName = splitString.last;
        if (!fileName.contains(".ncrypt")) {
          fileName += ".ncrypt";
        }

        splitString.removeAt(splitString.length - 1);
        String path = splitString.join("\\");

        SystemDataClient().export(path, fileName).then((response) {
          if (context.mounted) {
            if (response != null && response is String && response.isEmpty) {
              CustomToast.success(context, "Export successful");
            } else {
              CustomToast.error(context, response);
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.folder),
          title: _selectedLocation.isEmpty
              ? Text("Choose a directory to save exported data")
              : Text(_selectedLocation),
          trailing: ElevatedButton(
            onPressed: () {
              pickDirectory();
            },
            child: Text("Choose"),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            saveFile();
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}
