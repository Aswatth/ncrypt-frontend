import 'package:flutter/material.dart';
import 'package:frontend/custom_snack_bar/custom_snackbar.dart';
import 'package:frontend/custom_snack_bar/status.dart';
import 'package:frontend/general_pages/import.dart';
import 'package:frontend/general_pages/login_page.dart';

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

  final Map<String, bool> _passwordValidation = Map<String, bool>.from({
    "Should have at least one digit": false,
    "Should have at least one uppercase character": false,
    "Should have at least one special character !, @, #, \$, %, ^, &, *": false,
    "Should be of length between 8 - 16": false
  });

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  void setMasterPassword() {
    MasterPasswordClient()
        .setMasterPassword(_passwordController.text)
        .then((value) {
      if (value.isEmpty) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(status: Status.error, content: value).show());
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
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Looks like this is your first time.",
                    style: TextStyle(fontSize: 34),
                  ),
                  Text(
                    "Lets start by setting up the master password",
                    style: TextStyle(fontSize: 24),
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
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisibility,
                      decoration: InputDecoration(
                        label: Text(
                          "Enter master password",
                        ),
                        hintMaxLines: 16,
                        enabled: true,
                        hintStyle:
                            TextStyle(color: Colors.white24, fontSize: 14),
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_confirmPasswordVisibility,
                      decoration: InputDecoration(
                        label: Text(
                          "Confirm master password",
                        ),
                        hintMaxLines: 16,
                        hintStyle:
                            TextStyle(color: Colors.white24, fontSize: 14),
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setMasterPassword();
                        }
                      },
                      child: Text("Set master password".toUpperCase()),
                      style: ElevatedButton.styleFrom(
                          // backgroundColor: PRIMARY_COLOR,
                          // foregroundColor: BACKGROUND_COLOR
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      "This will be the only password you need to remember! ;)",
                      style:
                          TextStyle(fontSize: 14, fontStyle: FontStyle.italic),),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "Want to import existing information?",
                        style: TextStyle(color: Colors.white60),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ImportPage(showBackButton: true,)));
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
