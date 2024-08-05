import 'package:flutter/material.dart';
import 'package:frontend/clients/master_password_client.dart';
import 'package:frontend/custom_snack_bar/custom_snackbar.dart';
import 'package:frontend/custom_snack_bar/status.dart';

class UpdateMasterPasswordPage extends StatefulWidget {
  const UpdateMasterPasswordPage({super.key});

  @override
  State<UpdateMasterPasswordPage> createState() => _UpdateMasterPasswordPageState();
}

class _UpdateMasterPasswordPageState extends State<UpdateMasterPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void updateMasterPassword() {
    MasterPasswordClient().updateMasterPassword(_passwordController.text).then((value) {
      if(value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(status: Status.success, content: "Successfully updated!",).show());
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(status: Status.error, content: value,).show());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Update master password"),
      children: [
        Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Enter new master password"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password cannot be empty";
                      }
                      RegExp digitRegex = RegExp(r'\d');
                      RegExp uppercaseRegex = RegExp(r'[A-Z]');
                      RegExp specialCharRegex =
                      RegExp(r'[!@#$%^&*]');

                      if (!value.contains(digitRegex)) {
                        return "Must contain at least one digit";
                      }

                      if (!value.contains(uppercaseRegex)) {
                        return "Must contain at least one uppercase letter";
                      }

                      if (!value.contains(specialCharRegex)) {
                        return "Must contain at least one special character";
                      }

                      if (!(value.length >= 8 &&
                          value.length <= 16)) {
                        return "Must be of length between 8-16";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText:
                        "Confirm new master password"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password cannot be empty";
                      }

                      if (_passwordController.text != value) {
                        return "Passwords does not match";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            )),
        SimpleDialogOption(
          child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()) {
                      updateMasterPassword();
                    }
                  },
                  child: Text("Update".toUpperCase()))),
        )
      ],
    );
  }
}
