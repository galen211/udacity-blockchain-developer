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

//  final ThemeData _kShrineTheme = _buildShrineTheme();

  ThemeData _buildFlightSuretyTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      accentColor: kAccentColor,
      primaryColor: kPrimaryColor,
      buttonColor: kButtonColor,
      scaffoldBackgroundColor: kScaffoldBackgroundColor,
      cardColor: kCardColor,
      textSelectionColor: kTextSelectionColor,
      errorColor: kErrorColor,
      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: kPrimaryColor,
        colorScheme: base.colorScheme.copyWith(
          secondary: kSecondaryButtonColor,
        ),
      ),
      buttonBarTheme: base.buttonBarTheme.copyWith(
        buttonTextTheme: ButtonTextTheme.accent,
      ),
      primaryIconTheme: base.iconTheme.copyWith(color: kPrimaryIconThemeColor),
      inputDecorationTheme: InputDecorationTheme(
        border: CornersBorder(),
      ),
      textTheme: GoogleFonts.muliTextTheme(),
      primaryTextTheme: GoogleFonts.playfairDisplayTextTheme(),
      accentTextTheme: GoogleFonts.nunitoSansTextTheme(),
    );
  }
}
