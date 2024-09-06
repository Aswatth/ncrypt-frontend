import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/custom_toast.dart';
import 'package:frontend/general_pages/import.dart';
import 'package:frontend/general_pages/session_data.dart';
import 'package:frontend/general_pages/settings.dart';
import 'package:frontend/login_data_pages/login_data_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration:
                  BoxDecoration(color: AppColors().backgroundColor, boxShadow: [
                BoxShadow(
                  color: AppColors().accentColor,
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
                      child: Text(
                        "Ncrypt".toUpperCase(),
                        style: TextStyle(fontSize: 32, letterSpacing: 3),
                      ),
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
                                  return ImportPage();
                                });
                          },
                          child: Row(
                            children: [
                              Text(
                                "Import".toUpperCase(),
                              ),
                              Icon(
                                Icons.upload,
                                color: AppColors().textColor,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: () {
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
                          },
                          child: Row(
                            children: [
                              Text(
                                "Export".toUpperCase(),
                              ),
                              Icon(
                                Icons.download,
                                color: AppColors().textColor,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            SystemDataClient().logout().then((value) {
                              if (context.mounted) {
                                if (value == null || value.isEmpty) {
                                  Navigator.of(context).pop();
                                } else {
                                  CustomToast.error(context, value);
                                }
                              }
                            });
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
              decoration:
                  BoxDecoration(color: AppColors().backgroundColor, boxShadow: [
                BoxShadow(
                  color: AppColors().accentColor,
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
              children: [LoginDataPage(), Text("Note page"), SettingsPage()],
            ),
          ),
        ],
      )),
    );
  }
}
