import 'package:flutter/material.dart';
import 'package:flutter_dapp/pages/reactive_main_page.dart';
import 'package:flutter_dapp/prerequisites.dart';
import 'package:flutter_dapp/stores/account_store.dart';
import 'package:flutter_dapp/stores/contract_service.dart';
import 'package:flutter_dapp/stores/contract_store.dart';
import 'package:flutter_dapp/stores/event_store.dart';
import 'package:flutter_dapp/stores/flight_data_store.dart';
import 'package:flutter_dapp/stores/flight_registration_store.dart';
import 'package:flutter_dapp/stores/settings_store.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
          create: (_) => FlightDataStore(),
        ),
        Provider(
          create: (_) => SettingsStore(),
        ),
        Provider(
          create: (_) => EventStore(),
        ),
        ProxyProvider<FlightDataStore, AccountStore>(
          update: (_, data, __) => AccountStore(contractService, data),
        ),
        ProxyProvider<AccountStore, FlightRegistrationStore>(
          update: (_, account, __) => FlightRegistrationStore(account),
        ),
        ProxyProvider3<AccountStore, FlightDataStore, FlightRegistrationStore,
            ContractStore>(
          update: (_, account, data, flight, __) =>
              ContractStore(account, data, flight),
        ),
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
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      final store = Provider.of<SettingsStore>(context);
      return MaterialApp(
        title: appConstants.appBarTitleText,
        theme: store.lightTheme,
        darkTheme: store.darkTheme,
        themeMode: store.themeMode,
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
    });
  }
}
