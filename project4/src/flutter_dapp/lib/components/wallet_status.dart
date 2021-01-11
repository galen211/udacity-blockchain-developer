import 'package:flutter/material.dart';
import 'package:flutter_dapp/contract/account_store.dart';
import 'package:flutter_dapp/data/actor.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'account_qr.dart';

class WalletStatus extends StatelessWidget {
  Future<void> showAccountSelection(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final store = Provider.of<AccountStore>(context);
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Select Account'),
            content: SingleChildScrollView(
              child: Container(
                height: 400,
                width: 500,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<Actor>(
                        hint: Text("Choose an account to use"),
                        isDense: true,
                        isExpanded: true,
                        value: null,
                        items: store.accountsDropdown(),
                        onChanged: (value) {
                          setState(() {
                            store.accountChanged = false;
                            store.selectedActor = value;
                            store.accountChanged = true;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: AccountQr(),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Disconnect'),
                onPressed: () {
                  store.selectedActor = Actor.nullActor();
                  Navigator.of(context).pop();
                  final snackBar = SnackBar(
                    content: Text('Your account is now disconnected'),
                    duration: Duration(seconds: 3),
                  );
                  ScaffoldMessenger.maybeOf(context).showSnackBar(snackBar);
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  final snackBar = SnackBar(
                    content: Text(
                        'You are now transacting as "${store.selectedActor.actorName}" at address: ${store.selectedActor.address.hex}'),
                    duration: Duration(seconds: 3),
                  );
                  ScaffoldMessenger.maybeOf(context).showSnackBar(snackBar);
                },
              ),
            ],
          ),
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
              label: Text(store.selectedAccountDescription),
              avatar: Icon(
                Icons.circle,
                color: store.isAccountConnected ? Colors.green : Colors.red,
                size: 15,
              ),
              onPressed: () {
                showAccountSelection(context);
              },
            ),
          ],
        ),
      );
    });
  }
}
