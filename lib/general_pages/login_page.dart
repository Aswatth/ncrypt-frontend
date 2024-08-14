import 'package:flutter/material.dart';
import 'package:frontend/clients/master_password_client.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'package:frontend/custom_snack_bar/custom_snackbar.dart';
import 'package:frontend/custom_snack_bar/status.dart';
import 'package:frontend/general_pages/home.dart';
import 'package:frontend/general_pages/import.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _visibility = false;
  bool _onMouseOverImport = false;

  @override
  void initState() {
    super.initState();
  }

  void login() {
    SystemDataClient().login(_passwordController.text).then((value) {
      if (value.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(status: Status.error, content: value).show());
      } else {
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        )
            .then((value) {
          _passwordController.clear();
        });
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
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: !_visibility,
                        decoration: InputDecoration(
                          label: Text(
                            "Enter master password",
                          ),
                          hintMaxLines: 16,
                          hintStyle:
                              TextStyle(color: Colors.white24, fontSize: 14),
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
                          if(value == null || value.isEmpty) {
                            return "Password cannot be empty";
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      child: Text("LOG IN"),
                    ),
                  ],
                ),
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
    );
  }
}
