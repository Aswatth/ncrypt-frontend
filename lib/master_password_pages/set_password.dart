import 'package:flutter/material.dart';
import 'package:frontend/master_password_pages/login.dart';

import '../clients/master_password_client.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({super.key});

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  late MasterPasswordClient client;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    client = MasterPasswordClient();
  }

  void setPassword() {
    client.setMasterPassword(_passwordController.text).then((value) {
      if (value.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value),
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 400.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(hintText: "Enter master password"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                if (value.length < 8 || value.length > 16) {
                  return 'Password length must be between 8-16';
                }
              },
            ),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(hintText: "Confirm master password"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords does not match';
                }
              },
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() == false) {
                  //do nothing
                } else {
                  setPassword();
                }
              },
              child: Text("Set password"),
            ),
          ],
        ),
      ),
    );
  }
}
