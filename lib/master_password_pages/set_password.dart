import 'package:flutter/material.dart';
import 'package:Ncrypt/general_pages/import.dart';

import '../utils/NoPasteFormatter.dart';

class SetPassword extends StatefulWidget {
  final Function(String)? callback;

  SetPassword({super.key, this.callback});

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

  @override
  Widget build(BuildContext context) {
    return Center(
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
                          )
                        ],
                      );
                    }).toList()),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  inputFormatters: [
                    NoPasteFormatter()
                  ],
                  enableInteractiveSelection: false,
                  controller: _passwordController,
                  obscureText: !_passwordVisibility,
                  decoration: InputDecoration(
                    label: Text(
                      "Enter master password",
                    ),
                    hintMaxLines: 16,
                    enabled: true,
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                    hintText: "Master password",
                    suffixIcon: IconButton(
                      icon: _passwordVisibility
                          ? Icon(
                              Icons.visibility_off,
                              // color: TEXT_COLOR,
                            )
                          : Icon(Icons.visibility),
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
                        _passwordValidation["Should have at least one digit"] =
                            true;
                      } else {
                        _passwordValidation["Should have at least one digit"] =
                            false;
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
                  inputFormatters: [
                    NoPasteFormatter()
                  ],
                  enableInteractiveSelection: false,
                  controller: _confirmPasswordController,
                  obscureText: !_confirmPasswordVisibility,
                  decoration: InputDecoration(
                    label: Text(
                      "Confirm master password",
                    ),
                    hintMaxLines: 16,
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                    hintText: "Master password",
                    suffixIcon: IconButton(
                      icon: _confirmPasswordVisibility
                          ? Icon(
                              Icons.visibility_off,
                            )
                          : Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisibility =
                              !_confirmPasswordVisibility;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || (value != _passwordController.text)) {
                      return "Password does not match";
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
                        widget.callback!(_passwordController.text);
                      }
                    },
                    child: Text("next".toUpperCase()),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "This will be the only password you need to remember!",
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
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
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ImportPage();
                            });
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
    );
  }
}
