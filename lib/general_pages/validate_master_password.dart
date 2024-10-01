import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../clients/master_password_client.dart';
import '../utils/custom_toast.dart';

class ValidateMasterPassword extends StatefulWidget {
  final Function callback;

  ValidateMasterPassword({super.key, required this.callback});

  @override
  State<ValidateMasterPassword> createState() => _ValidateMasterPasswordState();
}

class _ValidateMasterPasswordState extends State<ValidateMasterPassword> {
  String enteredPassword = "";
  bool visibility = false;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return SimpleDialog(
        title: Text("Enter master password"),
        contentPadding: EdgeInsets.all(12),
        children: [
          TextFormField(
            enableInteractiveSelection: false,
            obscureText: !visibility,
            onChanged: (value) {
              setState(() {
                enteredPassword = value;
              });
            },
            decoration: InputDecoration(
                hintText: "Enter master password",
                label: Text("Master Password"),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        visibility = !visibility;
                      });
                    },
                    icon: visibility
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off))),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                MasterPasswordClient()
                    .validateMasterPassword(enteredPassword)
                    .then((value) {
                  if (value == "true") {
                    widget.callback(true);
                    Navigator.of(context).pop();
                  } else {
                    if (context.mounted) {
                      CustomToast.error(context, value);
                    }
                  }
                });
              },
              child: Text("Validate".toUpperCase()))
        ],
      );
    });
  }
}
