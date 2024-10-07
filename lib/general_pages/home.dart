import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:Ncrypt/clients/system_data_client.dart';
import 'package:Ncrypt/general_pages/password_generator.dart';
import 'package:Ncrypt/general_pages/signin_page.dart';
import 'package:Ncrypt/models/session_timer.dart';
import 'package:Ncrypt/notes/note_page.dart';
import 'package:Ncrypt/utils/custom_toast.dart';
import 'package:Ncrypt/general_pages/import.dart';
import 'package:Ncrypt/general_pages/session_data.dart';
import 'package:Ncrypt/general_pages/settings.dart';
import 'package:Ncrypt/login_data_pages/login_data_page.dart';

import '../models/system_data.dart';
import '../utils/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void exportData() {
    FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'backup.ncrypt',
        allowedExtensions: ['ncrypt']).then((value) {
      if (value != null) {
        List<String> splitString = value.split("\\");

        String fileName = splitString.last;
        if (!fileName.contains(".ncrypt")) {
          fileName += ".ncrypt";
        }

        splitString.removeAt(splitString.length - 1);
        String path = splitString.join("\\");

        SystemDataClient().export(path, fileName).then((response) {
          if (context.mounted) {
            if (response != null && response is String && response.isEmpty) {
              CustomToast.success(context, "Export successful");
            } else {
              CustomToast.error(context, response);
            }
          }
        });
      }
    });
  }

  void logout() {
    SystemDataClient().logout().then((value) {
      if (context.mounted) {
        if (value.isEmpty) {
          SessionTimer().reset();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => SignInPage(),
            ),
            (route) => false,
          );
        } else {
          CustomToast.error(context, value);
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final ThemeProvider? themeProvider = ThemeProvider.of(context);
    SystemDataClient().getSystemData().then((value) {
      if(value != null && value is SystemData) {
        setState(() {
          themeProvider!.setThemeMode(value.theme);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor,
                      offset: Offset(0, -2),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    )
                  ]),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text("Ncrypt".toUpperCase(),
                          style: Theme.of(context).textTheme.headlineLarge),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return PasswordGenerator();
                                });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.password,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                "Password generator".toUpperCase(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return ImportPage();
                                });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.upload,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                              Text(
                                "Import".toUpperCase(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: () {
                            exportData();
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.download,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                              Text(
                                "Export".toUpperCase(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            //Auto backup
                            if (SystemDataClient()
                                .SYSTEM_DATA!
                                .autoBackupSetting
                                .isEnabled) {
                              SystemDataClient().backup().then((value) {
                                if (value is String && value.isNotEmpty) {
                                  if (context.mounted) {
                                    CustomToast.error(context, value);
                                  }
                                } else {
                                  logout();
                                }
                              });
                            } else {
                              logout();
                            }
                          },
                          icon: Icon(Icons.logout),
                          label: Text(
                            "Logout".toUpperCase(),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: HomeContent(),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor,
                      offset: Offset(0, 2),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    )
                  ]),
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                  child: SessionData()),
            ),
          )
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool isHovering = false;

  List<Widget> mouseExitWidget() {
    return [
      Icon(Icons.person_2_outlined),
      SizedBox(
        height: 20,
      ),
      Icon(Icons.note_outlined),
      SizedBox(
        height: 20,
      ),
      Icon(Icons.settings),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          body: Column(
        children: [
          TabBar(automaticIndicatorColorAdjustment: true, tabs: [
            Tab(
              icon: Icon(
                Icons.person_2_outlined,
              ),
              text: "Login profiles".toUpperCase(),
            ),
            Tab(
              icon: Icon(Icons.note_outlined),
              text: "Notes".toUpperCase(),
            ),
            Tab(
              icon: Icon(Icons.settings),
              text: "Settings".toUpperCase(),
            )
          ]),
          Expanded(
            child: TabBarView(
              children: [LoginDataPage(), NotePage(), SettingsPage()],
            ),
          ),
        ],
      )),
    );
  }
}
