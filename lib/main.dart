import 'dart:io';
import 'dart:ui';

import 'package:Ncrypt/clients/login_data_client.dart';
import 'package:Ncrypt/clients/notes_client.dart';
import 'package:flutter/material.dart';
import 'package:Ncrypt/general_pages/setup.dart';
import 'package:Ncrypt/models/session_timer.dart';
import 'package:Ncrypt/utils/system.dart';
import 'package:Ncrypt/clients/master_password_client.dart';
import 'package:Ncrypt/clients/system_data_client.dart';
import 'package:Ncrypt/utils/custom_toast.dart';
import 'package:Ncrypt/general_pages/signin_page.dart';
import 'package:Ncrypt/utils/theme_provider.dart';

void main(List<String> args) async {
  System().PORT = int.parse(args[0]);
  System().IsNewUser = bool.parse(args[1]);
  System().THEME = args[2];

  SystemDataClient();
  MasterPasswordClient();
  LoginDataClient();
  NotesClient();
  SessionTimer();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  ThemeMode _currentThemeMode = ThemeMode.system;

  void setThemeMode(String theme) {
    setState(() {
      switch (theme) {
        case "DARK":
          _currentThemeMode = ThemeMode.dark;
          break;
        case "LIGHT":
          _currentThemeMode = ThemeMode.light;
          break;
        case "SYSTEM":
          _currentThemeMode = ThemeMode.system;
          break;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setThemeMode(System().THEME);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      setThemeMode: setThemeMode,
      themeMode: _currentThemeMode,
      child: MaterialApp(
        title: 'Ncrypt'.toUpperCase(),
        theme: ThemeProvider.generateTheme(false),
        darkTheme: ThemeProvider.generateTheme(true),
        themeMode: _currentThemeMode,
        home: LoadPage(),
      ),
    );
  }
}

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  @override
  void initState() {
    super.initState();
    AppLifecycleListener(onExitRequested: _handleExitRequested);
  }

  Future<AppExitResponse> _handleExitRequested() async {
    if (SystemDataClient().SYSTEM_DATA == null ||
        !SystemDataClient().SYSTEM_DATA!.autoBackupSetting.isEnabled) {
      return AppExitResponse.exit;
    }

    SystemDataClient().backup().then((value) {
      if (value == null || (value is String && value.isEmpty)) {
        exit(0);
      } else {
        if (context.mounted) {
          CustomToast.error(context, value);
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text("Force exit?"),
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                      child:
                          Text("Error occured while automatically backing up!"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close),
                          label: Text("No"),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            exit(0);
                          },
                          icon: Icon(Icons.check),
                          label: Text("Yes"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            // Background color
                            foregroundColor:
                                Theme.of(context).textTheme.bodyMedium?.color,
                            // Text color
                            side: BorderSide(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color!, // Border color
                              width: 2, // Border width
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                );
              });
        }
      }
    });

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              Center(
                child: Text("Backing up data"),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          );
        });
    return AppExitResponse.cancel;
  }

  @override
  Widget build(BuildContext context) {
    return System().IsNewUser ? Setup() : SignInPage();
  }
}
