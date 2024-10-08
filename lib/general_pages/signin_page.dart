import 'package:Ncrypt/utils/NoPasteFormatter.dart';
import 'package:flutter/material.dart';
import 'package:Ncrypt/clients/system_data_client.dart';
import 'package:Ncrypt/utils/custom_toast.dart';
import 'package:Ncrypt/general_pages/home.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _visibility = false;

  void login() {
    SystemDataClient().signin(_passwordController.text).then((value) {
      if (context.mounted) {
        if (value.isNotEmpty) {
          CustomToast.error(context, value);
        } else {
          Navigator.of(context)
              .pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (route) => false,
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
          elevation: 10,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // adjust the border radius as needed
              side: BorderSide(
                  color: Theme.of(context).textTheme.bodyMedium!.color!
              )
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ncrypt".toUpperCase(),
                  style: Theme.of(context).textTheme.headlineLarge,
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
                    inputFormatters: [
                      NoPasteFormatter()
                    ],
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
                    child: Text("sign in".toUpperCase()),
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
