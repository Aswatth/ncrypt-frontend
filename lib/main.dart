import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/general_pages/setup.dart';
import 'package:frontend/models/session_timer.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/system.dart';
import 'package:frontend/clients/master_password_client.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'package:frontend/utils/custom_toast.dart';
import 'package:frontend/general_pages/signin_page.dart';

void main(List<String> args) async {
  System().PORT = int.parse(args[0]);
  System().IsNewUser = bool.parse(args[1]);

  SystemDataClient();
  MasterPasswordClient();
  SessionTimer();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double largeText = 18.0;
    double mediumText = 14.0;
    double smallText = 12.0;

    return MaterialApp(
      title: 'Ncrypt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors().primaryColor,
          primary: AppColors().primaryColor,
          secondary: AppColors().secondaryColor,
          surface: AppColors().backgroundColor,
        ),
        cardTheme: CardTheme(
            shadowColor: AppColors().primaryColor,
            color: AppColors().backgroundColor),
        checkboxTheme: CheckboxThemeData(
            // fillColor: WidgetStatePropertyAll(AppColors().backgroundColor),
            ),
        tabBarTheme: TabBarTheme(
          labelColor: AppColors().primaryColor,
          indicatorColor: AppColors().primaryColor,
        ),
        textTheme: TextTheme(
          bodyLarge:
              TextStyle(color: AppColors().textColor, fontSize: largeText),
          bodyMedium:
              TextStyle(color: AppColors().textColor, fontSize: mediumText),
          bodySmall:
              TextStyle(color: AppColors().textColor, fontSize: smallText),
          titleLarge:
              TextStyle(color: AppColors().textColor, fontSize: largeText),
          titleMedium:
              TextStyle(color: AppColors().textColor, fontSize: mediumText),
          titleSmall:
              TextStyle(color: AppColors().textColor, fontSize: smallText),
          labelLarge:
              TextStyle(color: AppColors().textColor, fontSize: largeText),
          labelMedium:
              TextStyle(color: AppColors().textColor, fontSize: mediumText),
          labelSmall:
              TextStyle(color: AppColors().textColor, fontSize: smallText),
          displayLarge:
              TextStyle(color: AppColors().textColor, fontSize: largeText),
          displayMedium:
              TextStyle(color: AppColors().textColor, fontSize: mediumText),
          displaySmall:
              TextStyle(color: AppColors().textColor, fontSize: smallText),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                foregroundColor: AppColors().textColor,
                textStyle:
                    TextStyle(letterSpacing: 2, color: AppColors().textColor))),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors().secondaryColor,
              foregroundColor: AppColors().textColor,
              textStyle:
                  TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
              // foregroundColor: AppColors().textColor,
              iconColor: AppColors().textColor),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: AppColors().backgroundColor,
          labelStyle: TextStyle(color: AppColors().textColor, fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide:
                BorderSide(color: AppColors().secondaryColor, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide:
                BorderSide(color: AppColors().secondaryColor, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide:
                BorderSide(color: AppColors().secondaryColor, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: AppColors().textColor, width: 1.0),
          ),
          errorStyle: TextStyle(fontWeight: FontWeight.bold),
          suffixIconColor: AppColors().textColor,
        ),
        scaffoldBackgroundColor: AppColors().backgroundColor,
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(color: AppColors().textColor),
          backgroundColor: AppColors().backgroundColor,
          foregroundColor: AppColors().textColor,
          iconTheme: IconThemeData(color: AppColors().primaryColor),
        ),
        listTileTheme: ListTileThemeData(
            titleTextStyle: TextStyle(color: AppColors().textColor),
            iconColor: AppColors().primaryColor,
            visualDensity: VisualDensity.comfortable),
        iconTheme: IconThemeData(
          color: AppColors().primaryColor,
        ),
        dialogBackgroundColor: AppColors().backgroundColor,
        dialogTheme: DialogTheme(
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: largeText,
              color: AppColors().textColor),
          contentTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: mediumText,
              color: AppColors().textColor),
          alignment: Alignment.center,
        ),
      ),
      themeMode: ThemeMode.dark,
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
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("No"),
                        ),
                        SizedBox(
                          width: 20,
                        ),
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
    return System().IsNewUser ? Setup() : SignInPage();
  }
}
