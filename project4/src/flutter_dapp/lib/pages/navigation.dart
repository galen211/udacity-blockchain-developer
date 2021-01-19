import 'package:flutter/material.dart';
import 'package:flutter_dapp/components/transaction_status.dart';
import 'package:flutter_dapp/components/wallet_status.dart';
import 'package:flutter_dapp/stores/account_store.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

_launchURL() async {
  const url =
      'https://github.com/galen211/udacity-blockchain-developer/tree/master/project4';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountStore>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
      body: Container(),
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
            store.selectedPageIndex = index;
          });
        },
      ),
    );
  }
}
