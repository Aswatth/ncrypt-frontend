import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/utils/system.dart';
import 'package:frontend/clients/master_password_client.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'package:frontend/utils/custom_toast.dart';
import 'package:frontend/general_pages/login_page.dart';
import 'package:frontend/master_password_pages/set_password.dart';

void main(List<String> args) async {
  System().PORT = int.parse(args[0]);
  System().IsNewUser = bool.parse(args[1]);

  SystemDataClient();
  MasterPasswordClient();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    HSLColor backgroundHSL = HSLColor.fromAHSL(1.0, 177.0, 0.51, 0.07);
    HSLColor textHSL = HSLColor.fromAHSL(1.0, 177.0, 0.45, 0.91);
    HSLColor primaryHSL = HSLColor.fromAHSL(1.0, 177.0, 0.6, 0.75);
    HSLColor secondaryHSL = HSLColor.fromAHSL(1.0, 177, 0.68, 0.30);
    HSLColor accentHSL = HSLColor.fromAHSL(1.0, 177, 0.75, 0.52);

    Color backgroundColor = backgroundHSL.toColor();
    Color textColor = textHSL.toColor();
    Color primaryColor = primaryHSL.toColor();
    Color secondaryColor = secondaryHSL.toColor();
    Color accentColor = accentHSL.toColor();

    double largeText = 18.0;
    double mediumText = 14.0;
    double smallText = 12.0;

    return MaterialApp(
      title: 'Ncrypt',
      theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: primaryColor,
                primary: primaryColor,
                secondary: secondaryColor,
                surface: backgroundColor,
              ),
              switchTheme: SwitchThemeData(
                  thumbColor: WidgetStatePropertyAll(backgroundColor)),
              textTheme: TextTheme(
                bodyLarge: TextStyle(color: textColor, fontSize: largeText),
                bodyMedium: TextStyle(color: textColor, fontSize: mediumText),
                bodySmall: TextStyle(color: textColor, fontSize: smallText),
                titleLarge: TextStyle(color: textColor, fontSize: largeText),
                titleMedium: TextStyle(color: textColor, fontSize: mediumText),
                titleSmall: TextStyle(color: textColor, fontSize: smallText),
              ),
              cardTheme: CardTheme(color: backgroundColor),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      foregroundColor: textColor,
                      textStyle: TextStyle(
                        fontSize: mediumText,
                        fontWeight: FontWeight.bold,
                      ),
                      // foregroundColor: textColor,
                      iconColor: textColor)),
              expansionTileTheme: ExpansionTileThemeData(
                  backgroundColor: backgroundColor,
                  iconColor: accentColor,
                  textColor: accentColor,
                  collapsedTextColor: textColor,
                  collapsedIconColor: textColor,
                  collapsedBackgroundColor: backgroundColor),
              inputDecorationTheme:
                  InputDecorationTheme(hintStyle: TextStyle(color: textColor)),
              scaffoldBackgroundColor: backgroundColor,
              appBarTheme: AppBarTheme(
                  titleTextStyle: TextStyle(color: textColor),
                  backgroundColor: backgroundColor,
                  foregroundColor: textColor,
                  iconTheme: IconThemeData(color: primaryColor)),
              listTileTheme: ListTileThemeData(
                  titleTextStyle: TextStyle(color: textColor),
                  iconColor: primaryColor,
                  visualDensity: VisualDensity.comfortable),
              iconTheme: IconThemeData(
                color: primaryColor,
              ),
              dialogBackgroundColor: backgroundColor,
              dialogTheme: DialogTheme(
                titleTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: largeText,
                    color: textColor),
                contentTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: mediumText,
                    color: textColor),
                alignment: Alignment.center,
              ),
              snackBarTheme: SnackBarThemeData(
                  showCloseIcon: true,
                  elevation: 20.0,
                  closeIconColor: Colors.white))
          .copyWith(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: backgroundColor,
          labelStyle: TextStyle(color: textColor, fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: secondaryColor, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: secondaryColor, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: secondaryColor, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: textColor, width: 1.0),
          ),
          errorStyle: TextStyle(fontWeight: FontWeight.bold),
          hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
          suffixIconColor: textColor,
        ),
      ),
      home: LoadPage(),
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
        !SystemDataClient().SYSTEM_DATA!.automaticBackup) {
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
                      padding: EdgeInsets.fromLTRB(20, 0,0,10),
                      child: Text("Error occured while automatically backing up!"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("No"),
                        ),
                        SizedBox(width: 20,),
                        ElevatedButton(
                          onPressed: () {
                            exit(0);
                          },
                          child: Text("Yes"),
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
    return System().IsNewUser ? SetPassword() : LoginPage();
  }
}
