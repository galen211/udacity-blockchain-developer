import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dapp/components/reactive_main_page.dart';
import 'package:flutter_dapp/contract/account_store.dart';
import 'package:flutter_dapp/contract/contract_service.dart';
import 'package:flutter_dapp/contract/contract_store.dart';
import 'package:flutter_dapp/contract/prerequisites.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

final App appConstants = App.settings;
ContractService contractService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Prerequisites prerequisites = Prerequisites();
  await prerequisites.initializationDone;
  contractService = ContractService();
  runApp(FlightSuretyApp());
}

class FlightSuretyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => AccountStore(contractService),
        ),
        ProxyProvider<AccountStore, ContractStore>(
            update: (_, account, __) => ContractStore(account))
      ],
      child: AppHome(),
    );
  }
}

class AppHome extends StatefulWidget {
  const AppHome({Key key}) : super(key: key);

  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  ThemeMode themeMode;

  @override
  void initState() {
    super.initState();
    themeMode = ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    const FlexScheme usedFlexScheme = FlexScheme.deepBlue;

    return MaterialApp(
      title: appConstants.appBarTitleText,
      theme: FlexColorScheme.light(
        colors: FlexColor.schemes[usedFlexScheme].light,
        appBarElevation: 12,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ).toTheme.copyWith(
          textTheme: GoogleFonts.muliTextTheme(ThemeData.light().textTheme),
          primaryTextTheme:
              GoogleFonts.robotoTextTheme(ThemeData.light().textTheme),
          accentTextTheme:
              GoogleFonts.nunitoSansTextTheme(ThemeData.light().textTheme)),
      darkTheme: FlexColorScheme.dark(
        colors: FlexColor.schemes[usedFlexScheme].dark,
        appBarElevation: 12,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ).toTheme.copyWith(
            textTheme: GoogleFonts.muliTextTheme(ThemeData.dark().textTheme),
            primaryTextTheme:
                GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
            accentTextTheme:
                GoogleFonts.nunitoSansTextTheme(ThemeData.dark().textTheme),
          ),
      themeMode: themeMode,
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: appConstants.backgroundImage, fit: BoxFit.cover),
        ),
        child: Builder(
          builder: (context) {
            final store = Provider.of<ContractStore>(context);
            return ReactiveMainPage(store);
          },
        ),
      ),
    );
  }
}
