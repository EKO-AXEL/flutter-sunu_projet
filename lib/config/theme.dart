 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sunu_projet/config/constants_colors.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: kWhiteColor,
    primaryColor: kPrimaryColor,
    appBarTheme: appBarTheme,
    textTheme: GoogleFonts.montserratAlternatesTextTheme(Theme.of(context).textTheme
    .apply(bodyColor: kDarkColor, displayColor: kDarkColor))
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: kDarkColor,
      primaryColor: kPrimaryColor,
      appBarTheme: appBarTheme.copyWith(
        backgroundColor: kPrimaryColor,
        titleTextStyle: TextStyle(
          color: kWhiteColor,
          fontSize: 24,
          fontWeight: FontWeight.bold
        )
      ),
      textTheme: GoogleFonts.montserratAlternatesTextTheme(Theme.of(context).textTheme
          .apply(bodyColor: kWhiteColor, displayColor: kWhiteColor))
  );
}

  const appBarTheme = AppBarTheme(
    centerTitle: false,
    backgroundColor: kPrimaryColor,
    iconTheme: IconThemeData(
      color: kWhiteColor
    ),
    titleTextStyle: TextStyle(
      color: kDarkColor,
      fontSize:24,
      fontWeight: FontWeight.bold
    )
  );
