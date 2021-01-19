import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobx/mobx.dart';

part 'settings_store.g.dart';

class SettingsStore = _SettingsStoreBase with _$SettingsStore;

abstract class _SettingsStoreBase with Store {
  @observable
  ThemeMode themeMode;

  @computed
  bool get isLightTheme => themeMode == ThemeMode.light;

  @observable
  FlexScheme usedFlexScheme;

  @observable
  ObservableList<FlexScheme> availableColorSchemes;

  _SettingsStoreBase() {
    themeMode = ThemeMode.light;
    usedFlexScheme = FlexScheme.deepBlue;
    availableColorSchemes = FlexScheme.values.asObservable();
  }

  @computed
  dynamic get lightTheme {
    return FlexColorScheme.light(
      colors: FlexColor.schemes[usedFlexScheme].light,
      appBarElevation: 12,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
    ).toTheme.copyWith(
        textTheme: GoogleFonts.muliTextTheme(ThemeData.light().textTheme),
        primaryTextTheme:
            GoogleFonts.robotoTextTheme(ThemeData.light().textTheme),
        accentTextTheme:
            GoogleFonts.nunitoSansTextTheme(ThemeData.light().textTheme));
  }

  @computed
  dynamic get darkTheme {
    return FlexColorScheme.dark(
      colors: FlexColor.schemes[usedFlexScheme].dark,
      appBarElevation: 12,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
    ).toTheme.copyWith(
          textTheme: GoogleFonts.muliTextTheme(ThemeData.dark().textTheme),
          primaryTextTheme:
              GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
          accentTextTheme:
              GoogleFonts.nunitoSansTextTheme(ThemeData.dark().textTheme),
        );
  }

  @computed
  String get currentSchemeName => FlexColor.schemes[usedFlexScheme].description;
}
