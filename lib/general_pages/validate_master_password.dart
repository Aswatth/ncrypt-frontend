import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../clients/master_password_client.dart';
import '../utils/NoPasteFormatter.dart';
import '../utils/custom_toast.dart';

class ValidateMasterPassword extends StatefulWidget {

  const ValidateMasterPassword({super.key});

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
            inputFormatters: [
              NoPasteFormatter()
            ],
            enableInteractiveSelection: false,
            obscureText: !visibility,
            onChanged: (value) {
              setState(() {
                enteredPassword = value;
              });
            },
            decoration: InputDecoration(
                label: Text("Master password"),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        visibility = !visibility;
                      });
                    },
                    icon: visibility
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility))),
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
                    if(context.mounted) {
                      Navigator.of(context).pop(true);
                    }
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
