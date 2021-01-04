import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'cut_corners_border.dart';

class FlightSuretyTheme {
  ThemeData _theme;

  ThemeData get theme => _theme;

  FlightSuretyTheme() {
    _theme = _buildFlightSuretyTheme();
  }

  ThemeData _buildFlightSuretyTheme() {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      accentColor: kAccentColor,
      primaryColor: kPrimaryColor,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: kAccentColor,
        behavior: SnackBarBehavior.floating,
      ),
      scaffoldBackgroundColor: kScaffoldBackgroundColor,
      cardColor: kCardColor,
      errorColor: kErrorColor,
      // buttonTheme: base.buttonTheme.copyWith(
      //   colorScheme: ColorScheme.highContrastDark().copyWith(
      //     primary: kAccentColor,
      //   ),
      // ),
      //   buttonColor: kAccentColor,
      //   disabledColor: kAccentColor,
      //   focusColor: kAccentColor,
      //   hoverColor: kAccentColor,
      //   highlightColor: kAccentColor,
      //   splashColor: kAccentColor,
      //   colorScheme: base.colorScheme.copyWith(
      //     primary: kAccentColor,
      //     primaryVariant: kAccentColor,
      //     secondary: kAccentColor,
      //     secondaryVariant: kAccentColor,
      //     surface: kAccentColor,
      //     background: kAccentColor,
      //     error: kAccentColor,
      //     onPrimary: kAccentColor,
      //     onSecondary: kAccentColor,
      //     onSurface: kAccentColor,
      //     onBackground: kAccentColor,
      //     onError: kAccentColor,
      //   ),
      // ),
      // buttonBarTheme: base.buttonBarTheme.copyWith(
      //   buttonTextTheme: ButtonTextTheme.accent,
      // ),
      primaryIconTheme: base.iconTheme.copyWith(color: kPrimaryIconThemeColor),
      inputDecorationTheme: InputDecorationTheme(
        border: CornersBorder(),
      ),
      textTheme: GoogleFonts.muliTextTheme(ThemeData.dark().textTheme),
      primaryTextTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
      accentTextTheme:
          GoogleFonts.nunitoSansTextTheme(ThemeData.dark().textTheme),
    );
  }
}
