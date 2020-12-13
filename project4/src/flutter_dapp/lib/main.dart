import 'package:flutter/material.dart';
import 'package:flutter_dapp/contract/contract_store.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:provider/provider.dart';
import 'components/main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FlightSuretyApp());
}

final App appConstants = App.settings;

class FlightSuretyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => ContractStore(),
        ),
      ],
      child: MaterialApp(
        title: appConstants.appBarTitleText,
        theme: ThemeData.dark(), //dark theme
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
