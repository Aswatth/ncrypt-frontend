import 'package:flutter/material.dart';
import 'package:Ncrypt/clients/master_password_client.dart';
import 'package:Ncrypt/utils/custom_toast.dart';

import '../utils/NoPasteFormatter.dart';

class UpdateMasterPasswordPage extends StatefulWidget {
  const UpdateMasterPasswordPage({super.key});

  @override
  State<UpdateMasterPasswordPage> createState() =>
      _UpdateMasterPasswordPageState();
}

class _UpdateMasterPasswordPageState extends State<UpdateMasterPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _oldMasterPasswordController = TextEditingController();
  bool _oldMasterPasswordVisibility = false;

  final _newMasterPasswordController = TextEditingController();
  bool _newMasterPasswordVisibility = false;

  bool _confirmMasterPasswordVisibility = false;
  final _confirmMasterPasswordController = TextEditingController();

  final Map<String, bool> _newMasterPasswordValidation = Map<String, bool>.from({
    "Should have at least one digit": false,
    "Should have at least one uppercase character": false,
    "Should have at least one special character !, @, #, \$, %, ^, &, *": false,
    "Should be of length between 8 - 16": false
  });

  void updateMasterPassword() {
    MasterPasswordClient()
        .updateMasterPassword(_oldMasterPasswordController.text, _newMasterPasswordController.text)
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _newMasterPasswordValidation.entries.map((m) {
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
                    inputFormatters: [
                      NoPasteFormatter()
                    ],
                    enableInteractiveSelection: false,
                    controller: _oldMasterPasswordController,
                    obscureText: !_oldMasterPasswordVisibility,
                    decoration: InputDecoration(
                      label: Text(
                        "Enter old master password",
                      ),
                      hintMaxLines: 16,
                      enabled: true,
                      hintStyle:
                      TextStyle(color: Colors.white24, fontSize: 14),
                      hintText: "Old master password",
                      suffixIcon: IconButton(
                        icon: _oldMasterPasswordVisibility
                            ? Icon(
                          Icons.visibility_off,
                          // color: TEXT_COLOR,
                        )
                            : Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _oldMasterPasswordVisibility = !_oldMasterPasswordVisibility;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Cannot be empty";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    inputFormatters: [
                      NoPasteFormatter()
                    ],
                    enableInteractiveSelection: false,
                    controller: _newMasterPasswordController,
                    obscureText: !_newMasterPasswordVisibility,
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
                        icon: _newMasterPasswordVisibility
                            ? Icon(
                          Icons.visibility_off,
                          // color: TEXT_COLOR,
                        )
                            : Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _newMasterPasswordVisibility = !_newMasterPasswordVisibility;
                          });
                        },
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (RegExp(r'[A-Z]').hasMatch(value)) {
                          _newMasterPasswordValidation[
                          "Should have at least one uppercase character"] =
                          true;
                        } else {
                          _newMasterPasswordValidation[
                          "Should have at least one uppercase character"] =
                          false;
                        }
                        if (RegExp(r'[0-9]').hasMatch(value)) {
                          _newMasterPasswordValidation[
                          "Should have at least one digit"] = true;
                        } else {
                          _newMasterPasswordValidation[
                          "Should have at least one digit"] = false;
                        }
                        if (RegExp(r'[!@#$%^&*]').hasMatch(value)) {
                          _newMasterPasswordValidation[
                          "Should have at least one special character !, @, #, \$, %, ^, &, *"] =
                          true;
                        } else {
                          _newMasterPasswordValidation[
                          "Should have at least one special character !, @, #, \$, %, ^, &, *"] =
                          false;
                        }
                        if ((value.length >= 8 && value.length <= 16)) {
                          _newMasterPasswordValidation[
                          "Should be of length between 8 - 16"] = true;
                        } else {
                          _newMasterPasswordValidation[
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
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    inputFormatters: [
                      NoPasteFormatter()
                    ],
                    enableInteractiveSelection: false,
                    controller: _confirmMasterPasswordController,
                    obscureText: !_confirmMasterPasswordVisibility,
                    decoration: InputDecoration(
                      label: Text(
                        "Confirm master password",
                      ),
                      hintMaxLines: 16,
                      hintStyle:
                      TextStyle(color: Colors.white24, fontSize: 14),
                      hintText: "master password",
                      suffixIcon: IconButton(
                        icon: _confirmMasterPasswordVisibility
                            ? Icon(
                          Icons.visibility_off,
                        )
                            : Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _confirmMasterPasswordVisibility =
                            !_confirmMasterPasswordVisibility;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          (value != _newMasterPasswordController.text)) {
                        return "Password does not match";
                      }
                      return null;
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
      ],
    );
  }
}
