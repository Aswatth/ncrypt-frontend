import 'package:flutter/material.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'package:frontend/general_pages/update_auto_backup.dart';
import 'package:frontend/models/session_timer.dart';
import 'package:frontend/utils/custom_toast.dart';
import 'package:frontend/master_password_pages/update_password.dart';
import 'package:frontend/utils/system.dart';
import 'package:frontend/utils/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            title: Text("Update master password".toUpperCase()),
            onTap: () {
              showDialog(
                  context: (context),
                  builder: (BuildContext context) {
                    return UpdateMasterPasswordPage();
                  });
            },
          ),
          ListTile(
            title: Text("Update automatic backup data".toUpperCase()),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      children: [UpdateAutoBackup()],
                    );
                  });
            },
          ),
          ListTile(
              title: Text("Session duration".toUpperCase()),
              trailing: SessionTimeout()),
          ListTile(
              title: Text("Update Theme".toUpperCase()),
              trailing: ThemeDropDown())
        ],
      ),
    );
  }
}

class SessionTimeout extends StatefulWidget {
  const SessionTimeout({super.key});

  @override
  State<SessionTimeout> createState() => _SessionTimeoutState();
}

class _SessionTimeoutState extends State<SessionTimeout> {
  final List<String> _timeoutList = [
    '10 minutes',
    '15 minutes',
    '20 minutes',
    '30 minutes'
  ];
  int selectedTimeout = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedTimeout = _timeoutList.indexOf(
        "${SystemDataClient().SYSTEM_DATA?.sessionDurationInMinutes} minutes");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: DropdownButton<String>(
        focusColor: Theme.of(context).scaffoldBackgroundColor,
        value: _timeoutList[selectedTimeout],
        items: _timeoutList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (selectedValue) {
          int timeInMinutes = int.parse(selectedValue!.split(" ")[0]);
          setState(() {
            selectedTimeout = _timeoutList.indexOf(selectedValue);
          });
          SystemDataClient().updateSessionTimeout(timeInMinutes).then((value) {
            if (value != null) {
              if (context.mounted) {
                CustomToast.error(context, value);
              }
            } else {
              SessionTimer().reset();
              SessionTimer().setSessionTimeInMinutes(timeInMinutes);
              SessionTimer().start();
            }
          });
        },
      ),
    );
  }
}

class ThemeDropDown extends StatefulWidget {
  const ThemeDropDown({super.key});

  @override
  State<ThemeDropDown> createState() => _ThemeDropDownState();
}

class _ThemeDropDownState extends State<ThemeDropDown> {
  late String selectedTheme;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedTheme = SystemDataClient().SYSTEM_DATA!.theme;
    });
  }

  void updateTheme(String theme) {
    SystemDataClient().updateTheme(theme).then((value) {
      if (value != null) {
        if (context.mounted) {
          CustomToast.error(context, value);
        }
      } else {
        setState(() {
          selectedTheme = theme;

          final themeProvider = ThemeProvider.of(context);
          themeProvider?.setThemeMode(selectedTheme);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        focusColor: Theme.of(context).scaffoldBackgroundColor,
        value: selectedTheme,
        items: ["LIGHT", "DARK", "SYSTEM"].map((String value) {
          return DropdownMenuItem<String>(
            child: Text(value),
            value: value,
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            updateTheme(value!);
          });
        },
      ),
    );
  }
}
