import 'package:flutter/material.dart';
import 'package:flutter_dapp/contract/account_store.dart';
import 'package:flutter_dapp/data/actor.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class WalletStatus extends StatefulWidget {
  @override
  _WalletStatusState createState() => _WalletStatusState();
}

class _WalletStatusState extends State<WalletStatus> {
  Future<void> _showMyDialog() async {
    final store = Provider.of<AccountStore>(context, listen: false);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Flight Surety'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                DropdownButtonFormField<Actor>(
                  hint: Text("Choose an account to use"),
                  isDense: true,
                  isExpanded: true,
                  value: store.selectedActor,
                  items: store.accountsDropdown(),
                  onChanged: (value) {
                    store.selectAccount(value);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                final snackBar = SnackBar(
                  content: Text(
                      'You are now transacting as ${store.actorName()} at address: ${store.selectedActor.address.hex}'),
                  duration: Duration(seconds: 3),
                );
                ScaffoldMessenger.maybeOf(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountStore>(context);
    return Observer(builder: (context) {
      return Container(
        child: Row(
          children: [
            ActionChip(
              label: Text(store.statusDescription),
              avatar: Icon(
                Icons.circle,
                color: store.isAccountConnected ? Colors.green : Colors.red,
                size: 15,
              ),
              onPressed: () {
                _showMyDialog();
              },
            ),
          ],
        ),
      );
    });
  }
}
