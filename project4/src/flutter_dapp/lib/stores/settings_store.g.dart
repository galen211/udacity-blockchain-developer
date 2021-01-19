// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SettingsStore on _SettingsStoreBase, Store {
  Computed<bool> _$isLightThemeComputed;

  @override
  bool get isLightTheme =>
      (_$isLightThemeComputed ??= Computed<bool>(() => super.isLightTheme,
              name: '_SettingsStoreBase.isLightTheme'))
          .value;
  Computed<dynamic> _$lightThemeComputed;

  @override
  dynamic get lightTheme =>
      (_$lightThemeComputed ??= Computed<dynamic>(() => super.lightTheme,
              name: '_SettingsStoreBase.lightTheme'))
          .value;
  Computed<dynamic> _$darkThemeComputed;

  @override
  dynamic get darkTheme =>
      (_$darkThemeComputed ??= Computed<dynamic>(() => super.darkTheme,
              name: '_SettingsStoreBase.darkTheme'))
          .value;
  Computed<String> _$currentSchemeNameComputed;

  @override
  String get currentSchemeName => (_$currentSchemeNameComputed ??=
          Computed<String>(() => super.currentSchemeName,
              name: '_SettingsStoreBase.currentSchemeName'))
      .value;

  final _$themeModeAtom = Atom(name: '_SettingsStoreBase.themeMode');

  @override
  ThemeMode get themeMode {
    _$themeModeAtom.reportRead();
    return super.themeMode;
  }

  @override
  set themeMode(ThemeMode value) {
    _$themeModeAtom.reportWrite(value, super.themeMode, () {
      super.themeMode = value;
    });
  }

  final _$usedFlexSchemeAtom = Atom(name: '_SettingsStoreBase.usedFlexScheme');

  @override
  FlexScheme get usedFlexScheme {
    _$usedFlexSchemeAtom.reportRead();
    return super.usedFlexScheme;
  }

  @override
  set usedFlexScheme(FlexScheme value) {
    _$usedFlexSchemeAtom.reportWrite(value, super.usedFlexScheme, () {
      super.usedFlexScheme = value;
    });
  }

  final _$availableColorSchemesAtom =
      Atom(name: '_SettingsStoreBase.availableColorSchemes');

  @override
  ObservableList<FlexScheme> get availableColorSchemes {
    _$availableColorSchemesAtom.reportRead();
    return super.availableColorSchemes;
  }

  @override
  set availableColorSchemes(ObservableList<FlexScheme> value) {
    _$availableColorSchemesAtom.reportWrite(value, super.availableColorSchemes,
        () {
      super.availableColorSchemes = value;
    });
  }

  @override
  String toString() {
    return '''
themeMode: ${themeMode},
usedFlexScheme: ${usedFlexScheme},
availableColorSchemes: ${availableColorSchemes},
isLightTheme: ${isLightTheme},
lightTheme: ${lightTheme},
darkTheme: ${darkTheme},
currentSchemeName: ${currentSchemeName}
    ''';
  }
}
