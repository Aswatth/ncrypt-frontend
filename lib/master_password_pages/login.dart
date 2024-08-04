import 'package:flutter/material.dart';
import 'package:frontend/clients/master_password_client.dart';
import 'package:frontend/login_data_pages/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  late final MasterPasswordClient client;

  @override
  void initState() {
    super.initState();
    client = MasterPasswordClient();
  }

  void login() {
    client.login(_passwordController.text).then((value) {
      if (value.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value),
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        ).then((value) {
          _passwordController.clear();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(hintText: "Enter master password"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == false) {
                    //do nothing
                  } else {
                    login();
                  }
                },
                child: Text("Log In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
