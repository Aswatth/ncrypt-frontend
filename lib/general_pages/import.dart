import 'package:Ncrypt/models/session_timer.dart';
import 'package:Ncrypt/models/system_data.dart';
import 'package:Ncrypt/utils/system.dart';
import 'package:Ncrypt/utils/theme_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:Ncrypt/clients/system_data_client.dart';
import 'package:Ncrypt/utils/custom_toast.dart';
import 'package:Ncrypt/general_pages/signin_page.dart';

import '../utils/NoPasteFormatter.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({super.key});

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  String _selectedLocation = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  bool _visibility = false;

  void loadFile() {
    FilePicker.platform.pickFiles(allowedExtensions: ['ncrypt']).then((value) {
      if (value != null) {
        setState(() {
          _selectedLocation = value.files.single.path!;
          if (!_selectedLocation.endsWith(".ncrypt")) {
            CustomToast.error(context, "Invalid file\nRequired .ncrypt file");
          }
        });
      }
    });
  }

  void import() {
    List<String> splitString = _selectedLocation.split("\\");

    String fileName = splitString.last;

    splitString.removeAt(splitString.length - 1);
    String path = splitString.join("\\");

    SystemDataClient()
        .import(path, fileName, _passwordController.text)
        .then((response) {
      if (context.mounted) {
        if (response != null && response is String && response.isEmpty) {
          CustomToast.success(context, "Import successful");

          if (!System().IsNewUser) {
            SessionTimer().reset();
          }

          final ThemeProvider? themeProvider = ThemeProvider.of(context);
          themeProvider?.updateThemeMode();

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SignInPage()),
            (route) => false,
          );
        } else {
          CustomToast.error(context, response);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Import"),
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Caution:\tImporting will over-write existing data.",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                ListTile(
                  leading: Icon(Icons.folder),
                  title: _selectedLocation.isEmpty
                      ? Text("Select a file to import")
                      : Text(_selectedLocation),
                  trailing: ElevatedButton(
                    onPressed: () {
                      loadFile();
                    },
                    child: Text("Choose".toUpperCase()),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  inputFormatters: [
                    NoPasteFormatter()
                  ],
                  enableInteractiveSelection: false,
                  controller: _passwordController,
                  obscureText: !_visibility,
                  decoration: InputDecoration(
                    label: Text(
                      "Enter master password",
                    ),
                    hintMaxLines: 16,
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                    hintText: "master password",
                    suffixIcon: IconButton(
                      icon: _visibility
                          ? Icon(Icons.visibility_off)
                          : Icon(
                              Icons.visibility,
                            ),
                      onPressed: () {
                        setState(() {
                          _visibility = !_visibility;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password cannot be empty";
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedLocation.isEmpty) {
                          CustomToast.error(context, "No file selected");
                        } else {
                          import();
                        }
                      }
                    },
                    child: Text("Import".toUpperCase()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
