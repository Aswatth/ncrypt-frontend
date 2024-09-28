import 'package:flutter/material.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'package:frontend/utils/custom_toast.dart';
import 'package:frontend/general_pages/home.dart';
import 'package:frontend/general_pages/password_generator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _visibility = false;

  @override
  void initState() {
    super.initState();
  }

  void login() {
    SystemDataClient().signin(_passwordController.text).then((value) {
      if (context.mounted) {
        if (value.isNotEmpty) {
          CustomToast.error(context, value);
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        width: 400,
        height: 200,
        child: Card(
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login".toUpperCase(),
                  style: TextStyle(fontSize: 32),
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    enableInteractiveSelection: false,
                    controller: _passwordController,
                    obscureText: !_visibility,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password cannot be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text(
                        "Enter master password",
                      ),
                      suffixIcon: _visibility
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _visibility = !_visibility;
                                });
                              },
                              icon: Icon(
                                Icons.visibility_off,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  _visibility = !_visibility;
                                });
                              },
                              icon: Icon(
                                Icons.visibility,
                              ),
                            ),
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()) {
                        login();
                      }
                    },
                    child: Text("Login".toUpperCase()),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
