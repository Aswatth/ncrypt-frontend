import 'package:flutter/material.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'package:frontend/master_password_pages/login.dart';
import 'package:frontend/master_password_pages/set_password.dart';

class MasterPasswordPage extends StatefulWidget {
  const MasterPasswordPage({super.key});

  @override
  State<MasterPasswordPage> createState() => _MasterPasswordPageState();
}

class _MasterPasswordPageState extends State<MasterPasswordPage> {
  Widget _selectedWidget= LoginPage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemDataClient client = SystemDataClient();
    client.getSystemData().then((value) {
      if (value is int) {
        if(value > 0) {
          setState(() {
            _selectedWidget = LoginPage();
          });
        }
      } else if(value is String && value.toUpperCase() == "KEY NOT FOUND"){
        //First time opening the application
        print("SETTING UP FIRST TIME");
        setState(() {
          _selectedWidget = SetPassword();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _selectedWidget;
  }
}
