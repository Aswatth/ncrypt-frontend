import 'package:flutter/material.dart';
import 'package:frontend/clients/env_loader.dart';
import 'package:frontend/home.dart';
import 'package:frontend/master_password_pages/main.dart';

void main() async {
  await EnvLoader().load("L:\\MyProjects\\Ncrypt\\backend\\.env");
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
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: textColor, fontSize: largeText),
              bodyMedium: TextStyle(color: textColor, fontSize: mediumText),
              bodySmall: TextStyle(color: textColor, fontSize: smallText),
              titleLarge: TextStyle(color: textColor, fontSize: largeText),
              titleMedium: TextStyle(color: textColor, fontSize: mediumText),
              titleSmall: TextStyle(color: textColor, fontSize: smallText),
            ),
            cardTheme: CardTheme(
              color: backgroundColor
            ),
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
                closeIconColor: Colors.white)),
        // home: MyHomePage(title: 'Ncrypt'),
        home: MasterPasswordPage());
  }
}
