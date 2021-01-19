import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dapp/components/app_body.dart';
import 'package:flutter_dapp/components/transaction_status.dart';
import 'package:flutter_dapp/components/wallet_status.dart';
import 'package:flutter_dapp/stores/account_store.dart';
import 'package:flutter_dapp/stores/contract_store.dart';
import 'package:flutter_dapp/stores/settings_store.dart';
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
          Observer(
            builder: (_) {
              final store = Provider.of<SettingsStore>(context);
              return IconButton(
                icon: store.isLightTheme
                    ? FaIcon(
                        FontAwesomeIcons.solidMoon,
                        size: 15,
                      )
                    : FaIcon(
                        FontAwesomeIcons.solidSun,
                        size: 15,
                      ),
                onPressed: () {
                  if (store.isLightTheme) {
                    store.themeMode = ThemeMode.dark;
                  } else {
                    store.themeMode = ThemeMode.light;
                  }
                },
              );
            },
          ),
          Observer(
              name: 'Color Scheme',
              builder: (context) {
                final store = Provider.of<SettingsStore>(context);
                return PopupMenuButton(
                  itemBuilder: (context) {
                    return FlexColor.schemes.entries
                        .map<PopupMenuItem>((scheme) {
                      return PopupMenuItem(
                          value: scheme.key,
                          child: ListTile(
                            title: Text('${scheme.value.name}'),
                            trailing: Icon(
                              Icons.lens,
                              color: store.isLightTheme
                                  ? scheme.value.light.primary
                                  : scheme.value.dark.primary,
                              size: 20,
                            ),
                          ));
                    }).toList();
                  },
                  tooltip: 'Current: ${store.currentSchemeName}',
                  icon: FaIcon(
                    FontAwesomeIcons.palette,
                    size: 15,
                  ),
                  onSelected: (scheme) {
                    store.usedFlexScheme = scheme;
                  },
                );
              }),
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
                      FontAwesomeIcons.usersCog,
                      size: 20,
                    ),
                    label: Text(
                      'Setup',
                    ),
                  ),
                  NavigationRailDestination(
                    icon: FaIcon(
                      FontAwesomeIcons.plane,
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
                      FontAwesomeIcons.globeEurope,
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
              ),
            ],
          );
        },
      ),
    );
  }
}
