import 'package:flutter/material.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'package:frontend/custom_toast/custom_toast.dart';
import 'package:frontend/general_pages/import.dart';
import 'package:frontend/general_pages/login_page.dart';
import 'package:frontend/utils/file_loader.dart';

import '../clients/master_password_client.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({super.key});

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  bool _passwordVisibility = false;
  bool _confirmPasswordVisibility = false;
  bool _onMouseOverImport = false;

  bool _automaticBackup = false;
  String _backupFolderPath = "";

  final Map<String, bool> _passwordValidation = Map<String, bool>.from({
    "Should have at least one digit": false,
    "Should have at least one uppercase character": false,
    "Should have at least one special character !, @, #, \$, %, ^, &, *": false,
    "Should be of length between 8 - 16": false
  });

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _backupFileNameController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _backupFileNameController = TextEditingController();
  }

  void setMasterPassword() {
    MasterPasswordClient()
        .setMasterPassword(_passwordController.text)
        .then((value) {
      if (context.mounted) {
        if (value.isEmpty) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => LoginPage()));
        } else {
          CustomToast.error(context, value);
        }
      }
    });
  }

  void setup() {
    SystemDataClient()
        .setup(_passwordController.text, _automaticBackup, _backupFolderPath,
            _backupFileNameController.text)
        .then((value) {
          if(context.mounted) {
            if (value == null || (value is String && value.isEmpty)) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
              );
            }
            else {
              CustomToast.error(context, value as String);
            }
          }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FittedBox(
          child: Form(
            key: _formKey,
            child: Container(
              width: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Setup",
                    style: TextStyle(fontSize: 34),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _passwordValidation.entries.map((m) {
                        return Row(
                          children: [
                            m.value
                                ? Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : Icon(Icons.close, color: Colors.red),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              m.key,
                              style: TextStyle(
                                  color: Colors.white60,
                                  fontStyle: FontStyle.italic),
                            )
                          ],
                        );
                      }).toList()),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisibility,
                    decoration: InputDecoration(
                      label: Text(
                        "Enter master password",
                      ),
                      hintMaxLines: 16,
                      enabled: true,
                      hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                      hintText: "master password",
                      suffixIcon: IconButton(
                        icon: _passwordVisibility
                            ? Icon(
                                Icons.visibility,
                                // color: TEXT_COLOR,
                              )
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _passwordVisibility = !_passwordVisibility;
                          });
                        },
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (RegExp(r'[A-Z]').hasMatch(value)) {
                          _passwordValidation[
                                  "Should have at least one uppercase character"] =
                              true;
                        } else {
                          _passwordValidation[
                                  "Should have at least one uppercase character"] =
                              false;
                        }
                        if (RegExp(r'[0-9]').hasMatch(value)) {
                          _passwordValidation[
                              "Should have at least one digit"] = true;
                        } else {
                          _passwordValidation[
                              "Should have at least one digit"] = false;
                        }
                        if (RegExp(r'[!@#$%^&*]').hasMatch(value)) {
                          _passwordValidation[
                                  "Should have at least one special character !, @, #, \$, %, ^, &, *"] =
                              true;
                        } else {
                          _passwordValidation[
                                  "Should have at least one special character !, @, #, \$, %, ^, &, *"] =
                              false;
                        }
                        if ((value.length >= 8 && value.length <= 16)) {
                          _passwordValidation[
                              "Should be of length between 8 - 16"] = true;
                        } else {
                          _passwordValidation[
                              "Should be of length between 8 - 16"] = false;
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Cannot be empty";
                      }
                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return "Must contain a upper case letter";
                      }
                      if (!RegExp(r'[0-9]').hasMatch(value)) {
                        return "Must contain a digit";
                      }
                      if (!RegExp(r'[!@#$%^&*]').hasMatch(value)) {
                        return "Must contain a special character";
                      }
                      if (!(value.length >= 8 && value.length <= 16)) {
                        return "Must be of length between 8-16";
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_confirmPasswordVisibility,
                    decoration: InputDecoration(
                      label: Text(
                        "Confirm master password",
                      ),
                      hintMaxLines: 16,
                      hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                      hintText: "master password",
                      suffixIcon: IconButton(
                        icon: _confirmPasswordVisibility
                            ? Icon(
                                Icons.visibility,
                              )
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _confirmPasswordVisibility =
                                !_confirmPasswordVisibility;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          (value != _passwordController.text)) {
                        return "Password does not match";
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      ListTile(
                        title: Text("Automatic backup on application close"),
                        trailing: Switch(
                            value: _automaticBackup,
                            onChanged: (value) {
                              setState(() {
                                _automaticBackup = value;
                              });
                            }),
                      ),
                      _automaticBackup
                          ? ListTile(
                              title: _backupFolderPath.isEmpty
                                  ? Text("Choose import data location")
                                  : Text(_backupFolderPath),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  FileUtils().pickFolder().then((value) {
                                    if (value == null) {
                                      if (context.mounted) {
                                        CustomToast.error(
                                            context, "Unable to select folder");
                                      }
                                    } else {
                                      setState(() {
                                        _backupFolderPath = value;
                                      });
                                    }
                                  });
                                },
                                child: Text("Choose"),
                              ),
                            )
                          : Container(),
                      _automaticBackup
                          ? ListTile(
                              title: TextFormField(
                                controller: _backupFileNameController,
                                maxLength: 16,
                                decoration: InputDecoration(
                                  label: Text(
                                    "Pick a file name",
                                  ),
                                  hintMaxLines: 16,
                                  hintStyle: TextStyle(
                                      color: Colors.white24, fontSize: 14),
                                  hintText: "File name",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "File name cannot be empty";
                                  }
                                  return null;
                                },
                              ),
                              subtitle: Text(
                                "The file name would be appended with date and time while saving.",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            )
                          : Container()
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setup();
                        }
                      },
                      child: Text("Complete Setup".toUpperCase()),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "This will be the only password you need to remember! ;)",
                      style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.white60),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Want to import existing information?",
                        style: TextStyle(color: Colors.white60),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => ImportPage(
                                    showBackButton: true,
                                    navigateToLogin: true,
                                  )));
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) {
                            setState(() {
                              _onMouseOverImport = true;
                            });
                          },
                          onExit: (_) {
                            setState(() {
                              _onMouseOverImport = false;
                            });
                          },
                          child: Row(
                            children: [
                              Icon(Icons.upload),
                              Text(
                                "Import",
                                style: TextStyle(
                                    decoration: _onMouseOverImport
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                    decorationThickness: 2),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
