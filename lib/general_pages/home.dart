import 'package:flutter/material.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'package:frontend/general_pages/export.dart';
import 'package:frontend/general_pages/import.dart';
import 'package:frontend/general_pages/session_timer.dart';
import 'package:frontend/general_pages/settings.dart';
import 'package:frontend/login_data_pages/login_data_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<IconData> _optionIconList = [
    Icons.security,
    Icons.note,
    Icons.upload,
    Icons.download,
    Icons.settings,
    Icons.logout
  ];
  final List<String> _optionText = [
    "Login",
    "Notes",
    "Import",
    "Export",
    "Settings",
    "Logout"
  ];
  final List<Widget> _optionContent = [
    LoginDataPage(),
    Text("Notes"),
    ImportPage(
      showBackButton: false,
      navigateToLogin: false,
    ),
    ExportPage(),
    SettingsPage()
  ];
  int _selectedIndex = 0;

  int sessionTime = 0;

  late HSLColor primaryHSL;
  late Color activeColor;
  late Color inactiveColor;

  @override
  void initState() {
    super.initState();
    primaryHSL = HSLColor.fromAHSL(1.0, 177, 0.75, 0.52);
    activeColor = primaryHSL.toColor();
    inactiveColor = Colors.white60;

    SystemDataClient().getSystemData().then((_){
      setState(() {
        sessionTime = SystemDataClient().SYSTEM_DATA.sessionTimeInMinutes;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            // color: Colors.deepPurple,
            width: MediaQuery.sizeOf(context).width * 0.25 > 400
                ? MediaQuery.sizeOf(context).width * 0.25
                : 400,
            // color: Colors.deepPurple,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width: double.infinity,
                    color: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Center(
                          child: Text(
                        "Ncrypt",
                        style:
                            TextStyle(color: Colors.greenAccent, fontSize: 50),
                      )),
                    )),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: _optionText.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(
                          _optionIconList[index],
                          color: _selectedIndex == index
                              ? activeColor
                              : inactiveColor,
                        ),
                        title: Text(
                          _optionText[index],
                          style: TextStyle(
                              color: _selectedIndex == index
                                  ? activeColor
                                  : inactiveColor),
                        ),
                        onTap: () {
                          setState(() {
                            if (index == _optionText.length - 1) {
                              Navigator.of(context).pop();
                            } else {
                              _selectedIndex = index;
                            }
                          });
                        },
                      );
                    }),
                sessionTime != 0
                    ? SessionTimer(time_in_seconds: sessionTime*60)
                    : Container()
              ],
            ),
          ),
          Expanded(child: _optionContent[_selectedIndex])
        ],
      ),
    );
  }
}
