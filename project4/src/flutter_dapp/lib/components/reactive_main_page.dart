import 'package:flutter/material.dart';
import 'package:flutter_dapp/components/transaction_status.dart';
import 'package:flutter_dapp/components/wallet_status.dart';
import 'package:flutter_dapp/contract/account_store.dart';
import 'package:flutter_dapp/contract/contract_store.dart';
import 'package:flutter_dapp/data/events.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'carousel.dart';

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

  ReactionDisposer _disposer;
  @override
  void initState() {
    super.initState();
    // a delay is used to avoid showing the snackbar too much when the connection drops in and out repeatedly
    _disposer = reaction<FlightSuretyEvent>(
      (_) => widget.store.eventStream.value,
      (FlightSuretyEvent event) =>
          ScaffoldMessenger.maybeOf(context).showSnackBar(
        SnackBar(
          content: Text(event.toString()),
          duration: Duration(seconds: 3),
        ),
      ),
      delay: 400,
      onError: (error, reaction) => debugPrint(
          "There was an error in the reaction Error: ${error.toString()} Reaction: ${reaction.errorValue}"),
    );
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountStore>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(appConstants.appBarTitleText),
        elevation: 0,
        backgroundColor: Colors.black54,
        leading: IconButton(
          tooltip: 'Click to see the code on Github',
          icon: FaIcon(FontAwesomeIcons.github),
          onPressed: _launchURL,
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
      body: ViewCarousel(),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 15,
        unselectedItemColor: Colors.white70,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.toolbox,
            ),
            label: 'Setup',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.planeDeparture,
            ),
            label: 'Airlines',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.passport,
            ),
            label: 'Passengers',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.calendar,
            ),
            label: 'Oracles',
          ),
        ],
        currentIndex: store.selectedPageIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: (index) {
          setState(() {
            store.selectPage(index);
          });
        },
      ),
    );
  }
}
