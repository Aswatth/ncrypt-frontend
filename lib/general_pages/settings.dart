import 'package:flutter/material.dart';
import 'package:frontend/master_password_pages/update_password.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("Automatic backup on application close"),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            title: Text("Update master password"),
            onTap: () {
              showDialog(
                  context: (context),
                  builder: (BuildContext context) {
                    return UpdateMasterPasswordPage();
                  });
            },
          )
        ],
      ),
    );
  }
}
