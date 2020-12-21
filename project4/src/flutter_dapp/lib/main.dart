import 'package:flutter/material.dart';
import 'package:flutter_dapp/contract/account_store.dart';
import 'package:flutter_dapp/contract/contract_store.dart';
import 'package:flutter_dapp/contract/prerequisites.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:provider/provider.dart';
import 'components/main_page.dart';

final App appConstants = App.settings;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Prerequisites prerequisites = Prerequisites();
  await prerequisites.initializationDone;
  runApp(FlightSuretyApp());
}

class FlightSuretyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => AccountStore(),
        ),
        Provider(
          create: (_) => ContractStore(),
        ),
      ],
      child: MaterialApp(
        title: appConstants.appBarTitleText,
        theme: appConstants.theme,
        home: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: appConstants.backgroundImage, fit: BoxFit.cover),
            ),
            child: MainPage(title: appConstants.appBarTitleText)),
      ),
    );
  }
}
