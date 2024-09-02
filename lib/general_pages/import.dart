import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'package:frontend/custom_toast/custom_toast.dart';
import 'package:frontend/general_pages/login_page.dart';

class ImportPage extends StatefulWidget {
  final bool showBackButton;
  final bool navigateToLogin;

  ImportPage(
      {super.key, required this.showBackButton, required this.navigateToLogin});

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
            CustomToast.error(context,
                "Invalid file\nRequired .ncrypt file");
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
          if (widget.navigateToLogin) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage()),
                (route) => false);
          }
        } else {
          CustomToast.error(context, response);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.showBackButton,
        title: Text("Import data",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                leading: Icon(Icons.folder),
                title: _selectedLocation.isEmpty
                    ? Text("Choose import data location")
                    : Text(_selectedLocation),
                trailing: ElevatedButton(
                  onPressed: () {
                    loadFile();
                  },
                  child: Text("Choose"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
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
                        ? Icon(Icons.visibility)
                        : Icon(
                            Icons.visibility_off,
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
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: Text("Please choose a file to import"),
                              );
                            });
                      } else {
                        import();
                      }
                    }
                  },
                  child: Text("Import"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
