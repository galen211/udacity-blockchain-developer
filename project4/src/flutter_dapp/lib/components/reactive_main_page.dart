import 'package:flutter/material.dart';
import 'package:flutter_dapp/components/app_body.dart';
import 'package:flutter_dapp/components/transaction_status.dart';
import 'package:flutter_dapp/components/wallet_status.dart';
import 'package:flutter_dapp/contract/account_store.dart';
import 'package:flutter_dapp/contract/contract_store.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

final App appConstants = App.settings;

_launchURL() async {
  const url =
      'https://github.com/galen211/udacity-blockchain-developer/tree/master/project4';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class ReactiveMainPage extends StatefulWidget {
  const ReactiveMainPage(this.store, {Key key}) : super(key: key);
  final ContractStore store;

  @override
  _ReactiveMainPageState createState() => _ReactiveMainPageState();
}

class _ReactiveMainPageState extends State<ReactiveMainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // ReactionDisposer _disposer;
  // // @override
  // void initState() {
  //   super.initState();
  //   // a delay is used to avoid showing the snackbar too much
  //   _disposer = reaction<FlightSuretyEvent>(
  //     (_) => widget.store.eventStream.value,
  //     (FlightSuretyEvent event) {
  //       // ScaffoldMessenger.maybeOf(context).removeCurrentSnackBar();
  //       // return ScaffoldMessenger.maybeOf(context).showSnackBar(
  //       //   SnackBar(
  //       //     content:
  //       //         Text('${event.eventType.eventName()} ${event.description()}'),
  //       //     duration: Duration(seconds: 3),
  //       //   ),
  //       // );
  //     },
  //     delay: 100,
  //     onError: (error, reaction) => debugPrint(
  //         "There was an error in the reaction Error: ${error.toString()} Reaction: ${reaction.errorValue}"),
  //   );
  // }

  // @override
  // void dispose() {
  //   _disposer();
  //   super.dispose();
  // }

  bool menuExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: menuExpanded
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    menuExpanded = false;
                  });
                })
            : IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  setState(() {
                    menuExpanded = true;
                  });
                }),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.84),
        title: Text(
          'Flight Surety',
          style: Theme.of(context).accentTextTheme.headline5.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontStyle: FontStyle.normal,
              ),
        ),
        actions: [
          WalletStatus(),
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 1.0),
          child: TransactionStatus(),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Observer(
        builder: (context) {
          final store = Provider.of<AccountStore>(context);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              NavigationRail(
                extended: menuExpanded,
                backgroundColor:
                    Theme.of(context).bottomAppBarColor.withOpacity(0.84),
                labelType: NavigationRailLabelType.none,
                selectedIndex: store.selectedPageIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    if (index == 4) {
                      _launchURL();
                    } else {
                      store.selectedPageIndex = index;
                    }
                  });
                },
                destinations: [
                  NavigationRailDestination(
                    icon: FaIcon(
                      FontAwesomeIcons.toolbox,
                      size: 20,
                    ),
                    label: Text(
                      'Setup',
                    ),
                  ),
                  NavigationRailDestination(
                    icon: FaIcon(
                      FontAwesomeIcons.planeDeparture,
                      size: 20,
                    ),
                    label: Text('Airlines'),
                  ),
                  NavigationRailDestination(
                    icon: FaIcon(
                      FontAwesomeIcons.passport,
                      size: 20,
                    ),
                    label: Text('Passengers'),
                  ),
                  NavigationRailDestination(
                    icon: FaIcon(
                      FontAwesomeIcons.calendar,
                      size: 20,
                    ),
                    label: Text('Oracles'),
                  ),
                  NavigationRailDestination(
                    icon: FaIcon(
                      FontAwesomeIcons.github,
                      size: 20,
                    ),
                    label: Text('Code'),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: AppBody(),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
