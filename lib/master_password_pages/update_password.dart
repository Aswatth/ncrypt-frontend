import 'package:flutter/material.dart';
import 'package:frontend/clients/master_password_client.dart';
import 'package:frontend/utils/custom_toast.dart';

class UpdateMasterPasswordPage extends StatefulWidget {
  const UpdateMasterPasswordPage({super.key});

  @override
  State<UpdateMasterPasswordPage> createState() =>
      _UpdateMasterPasswordPageState();
}

class _UpdateMasterPasswordPageState extends State<UpdateMasterPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _passwordVisibility = false;

  bool _confirmPasswordVisibility = false;
  final _confirmPasswordController = TextEditingController();

  final Map<String, bool> _passwordValidation = Map<String, bool>.from({
    "Should have at least one digit": false,
    "Should have at least one uppercase character": false,
    "Should have at least one special character !, @, #, \$, %, ^, &, *": false,
    "Should be of length between 8 - 16": false
  });

  void updateMasterPassword() {
    MasterPasswordClient()
        .updateMasterPassword(_passwordController.text)
        .then((value) {
      if (context.mounted) {
        if (value.isEmpty) {
          Navigator.of(context).pop();
          CustomToast.success(context, "Successfully updated!");
        } else {
          CustomToast.error(context, value);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(child: Text("Update master password")),
      children: [
        Form(
          key: _formKey,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                    // width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          updateMasterPassword();
                        }
                      },
                      child: Text("Update master password".toUpperCase()),
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: PRIMARY_COLOR,
                        // foregroundColor: BACKGROUND_COLOR
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
