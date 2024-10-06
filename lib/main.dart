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

  ThemeData themeData(bool isDark) {
    double largeText = 18.0;
    double mediumText = 14.0;
    double smallText = 12.0;

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: isDark
            ? AppColors().primaryColor_dark
            : AppColors().primaryColor_light,
        primary: isDark
            ? AppColors().primaryColor_dark
            : AppColors().primaryColor_light,
        secondary: isDark
            ? AppColors().secondaryColor_dark
            : AppColors().secondaryColor_light,
        surface: isDark
            ? AppColors().backgroundColor_dark
            : AppColors().backgroundColor_light,
      ),
      cardTheme: CardTheme(
          shadowColor: isDark
              ? AppColors().primaryColor_dark
              : AppColors().primaryColor_light,
          color: isDark
              ? AppColors().backgroundColor_dark
              : AppColors().backgroundColor_light),
      checkboxTheme: CheckboxThemeData(
          // fillColor: WidgetStatePropertyAll(isDark ? AppColors().backgroundColor_dark :AppColors().backgroundColor_light),
          ),
      tabBarTheme: TabBarTheme(
        unselectedLabelStyle: TextStyle(
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            fontStyle: FontStyle.normal),
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        labelColor: isDark
            ? AppColors().primaryColor_dark
            : AppColors().primaryColor_light,
        indicatorColor: isDark
            ? AppColors().primaryColor_dark
            : AppColors().primaryColor_light,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
            fontFamily: "ChakraPetch",
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            fontSize: 32,
            letterSpacing: 3),
        headlineMedium: TextStyle(
            fontFamily: "ChakraPetch",
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            fontSize: 28),
        headlineSmall: TextStyle(
            fontFamily: "ChakraPetch",
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            fontSize: 24),
        bodyLarge: TextStyle(
            fontFamily: "ChakraPetch",
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            fontSize: largeText),
        bodyMedium: TextStyle(
            fontFamily: "ChakraPetch",
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            fontSize: mediumText),
        bodySmall: TextStyle(
            fontFamily: "ChakraPetch",
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            fontSize: smallText),
        titleLarge: TextStyle(
            fontFamily: "ChakraPetch",
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            fontSize: largeText),
        titleMedium: TextStyle(
            fontFamily: "ChakraPetch",
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            fontSize: mediumText),
        titleSmall: TextStyle(
            fontFamily: "ChakraPetch",
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            fontSize: smallText),
        labelLarge: TextStyle(
            fontFamily: "ChakraPetch",
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            fontSize: largeText),
        labelMedium: TextStyle(
            fontFamily: "ChakraPetch",
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            fontSize: mediumText),
        labelSmall: TextStyle(
            fontFamily: "ChakraPetch",
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            fontSize: smallText),
        displayLarge: TextStyle(
            fontFamily: "ChakraPetch",
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            fontSize: largeText),
        displayMedium: TextStyle(
            fontFamily: "ChakraPetch",
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            fontSize: mediumText),
        displaySmall: TextStyle(
            fontFamily: "ChakraPetch",
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            fontSize: smallText),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: isDark
                  ? AppColors().textColor_dark
                  : AppColors().textColor_light,
              textStyle: TextStyle(
                  fontFamily: "ChakraPetch",
                  letterSpacing: 2,
                  color: isDark
                      ? AppColors().textColor_dark
                      : AppColors().textColor_light))),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: isDark
                ? AppColors().secondaryColor_dark
                : AppColors().secondaryColor_light,
            foregroundColor: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            textStyle: TextStyle(
                fontFamily: "ChakraPetch",
                fontWeight: FontWeight.bold,
                letterSpacing: 2),
            // foregroundColor: isDark ? AppColors().textColor_dark :AppColors().textColor_light,
            iconColor: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(fontFamily: "ChakraPetch", color: Colors.grey),
        filled: true,
        fillColor: isDark
            ? AppColors().backgroundColor_dark
            : AppColors().backgroundColor_light,
        labelStyle: TextStyle(
            fontFamily: "ChakraPetch",
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
              color: isDark
                  ? AppColors().secondaryColor_dark
                  : AppColors().secondaryColor_light,
              width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
              color: isDark
                  ? AppColors().secondaryColor_dark
                  : AppColors().secondaryColor_light,
              width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
              color: isDark
                  ? AppColors().secondaryColor_dark
                  : AppColors().secondaryColor_light,
              width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
              color: isDark
                  ? AppColors().textColor_dark
                  : AppColors().textColor_light,
              width: 1.0),
        ),
        errorStyle:
            TextStyle(fontFamily: "ChakraPetch", fontWeight: FontWeight.bold),
        suffixIconColor:
            isDark ? AppColors().textColor_dark : AppColors().textColor_light,
      ),
      scaffoldBackgroundColor: isDark
          ? AppColors().backgroundColor_dark
          : AppColors().backgroundColor_light,
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
            fontFamily: "ChakraPetch",
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light,
            fontSize: 28),
        backgroundColor: isDark
            ? AppColors().backgroundColor_dark
            : AppColors().backgroundColor_light,
        foregroundColor:
            isDark ? AppColors().textColor_dark : AppColors().textColor_light,
        iconTheme: IconThemeData(
            color: isDark
                ? AppColors().primaryColor_dark
                : AppColors().primaryColor_light),
      ),
      listTileTheme: ListTileThemeData(
          titleTextStyle: TextStyle(
              fontSize: mediumText,
              fontFamily: "ChakraPetch",
              color: isDark
                  ? AppColors().textColor_dark
                  : AppColors().textColor_light),
          subtitleTextStyle: TextStyle(
            fontStyle: FontStyle.italic,
              fontFamily: "ChakraPetch",
              color: isDark
                  ? AppColors().textColor_dark
                  : AppColors().textColor_light),
          iconColor: isDark
              ? AppColors().primaryColor_dark
              : AppColors().primaryColor_light,
          visualDensity: VisualDensity.comfortable),
      iconTheme: IconThemeData(
        color: isDark
            ? AppColors().primaryColor_dark
            : AppColors().primaryColor_light,
      ),
      dialogBackgroundColor: isDark
          ? AppColors().backgroundColor_dark
          : AppColors().backgroundColor_light,
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            // adjust the border radius as needed
            side: BorderSide(
                color: isDark
                    ? AppColors().textColor_dark
                    : AppColors().textColor_light)),
        titleTextStyle: TextStyle(
            fontFamily: "ChakraPetch",
            fontWeight: FontWeight.bold,
            fontSize: largeText,
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light),
        contentTextStyle: TextStyle(
            fontFamily: "ChakraPetch",
            fontWeight: FontWeight.bold,
            fontSize: mediumText,
            color: isDark
                ? AppColors().textColor_dark
                : AppColors().textColor_light),
        alignment: Alignment.center,
      ),
    );
  }

  ThemeMode getThemeMode() {
     switch(System().THEME) {
       case "DARK": return ThemeMode.dark;
       case "LIGHT": return ThemeMode.light;
       case "SYSTEM": return ThemeMode.system;
     }
     return ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ncrypt'.toUpperCase(),
      theme: themeData(false),
      darkTheme: themeData(true),
      themeMode: getThemeMode(),
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
