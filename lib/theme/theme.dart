import 'package:flutter/material.dart';

const Color lightDarkColor = Color(0xFF1A1A1A);
const Color greyColor = Color(0xFFBFC8CA);
const Color lightButtonBackgroundColor = Color(0xFF282828);
const Color darkButtonBackgroundColor = Colors.white;

const Color tabLabelTextColorLightTheme = Color(0xFF575757);
const Color iconColorLightTheme = Color(0xFF575757);

const OutlineInputBorder lightInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
    borderRadius: BorderRadius.all(Radius.circular(15.0))
);

const OutlineInputBorder lightErrorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red),
    borderRadius: BorderRadius.all(Radius.circular(15.0))
);

const OutlineInputBorder darkInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(15.0))
);

const OutlineInputBorder darkErrorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red),
    borderRadius: BorderRadius.all(Radius.circular(15.0))
);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
          fontSize: 15.0
      ),
      enabledBorder: lightInputBorder,
      border: lightInputBorder,
      focusedBorder: lightInputBorder,
      errorBorder: lightErrorBorder,
      focusedErrorBorder: lightErrorBorder
  ),
  iconTheme: const IconThemeData(
    color: iconColorLightTheme
  ),
  tabBarTheme: const TabBarTheme(
      unselectedLabelColor: Color(0xFF646464)
  ),
  textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(lightButtonBackgroundColor)
      )
  ),
  colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: Colors.black,
      onPrimary: Colors.black,
      secondary: Colors.red,
      onSecondary: Colors.black,
      surface: Color(0xFFD2D2D2),
      onInverseSurface: Colors.black,
      error: Colors.red,
      onError: Colors.black,
      primaryContainer: lightDarkColor,
      onPrimaryContainer: Colors.black,
      secondaryContainer: Colors.grey,
      onSecondaryContainer: Colors.black
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFF121212),
  textTheme: const TextTheme(
      bodyMedium: TextStyle(
          color: Colors.white
      )
  ),
  inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
          fontSize: 15.0
      ),
      enabledBorder: darkInputBorder,
      border: darkInputBorder,
      focusedBorder: darkInputBorder,
      errorBorder: darkErrorBorder,
      focusedErrorBorder: darkErrorBorder
  ),
  tabBarTheme: const TabBarTheme(
      unselectedLabelColor: greyColor
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white)
    )
  ),
  dialogTheme: const DialogTheme(
      backgroundColor: lightDarkColor
  ),
  colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: Colors.white,
      onPrimary: Colors.black,
      secondary: Colors.red,
      onSecondary: Colors.black,
      surface: lightDarkColor,
      onSurface: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      primaryContainer: lightDarkColor,
      onPrimaryContainer: Colors.white,
      secondaryContainer: Colors.grey,
      onSecondaryContainer: Colors.black
  )
);