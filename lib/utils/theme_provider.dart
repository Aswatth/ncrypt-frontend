import 'package:flutter/material.dart';
import 'package:Ncrypt/utils/colors.dart';

class ThemeProvider extends InheritedWidget {
  final ThemeMode themeMode;
  final void Function(String theme) setThemeMode;

  const ThemeProvider({
    super.key,
    required this.themeMode,
    required this.setThemeMode,
    required super.child,
  });

  static ThemeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
  }


  static ThemeData generateTheme(bool isDark) {
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

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    print("Updated theme");
    return true;
  }
}