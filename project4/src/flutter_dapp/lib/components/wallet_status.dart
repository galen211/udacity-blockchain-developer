import 'package:flutter/material.dart';
import 'package:flutter_dapp/data/enums.dart';
import 'package:flutter_dapp/stores/account_store.dart';
import 'package:flutter_dapp/stores/actor_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'account_qr.dart';

class WalletStatus extends StatelessWidget {
  Future<void> showAccountSelection(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final store = Provider.of<AccountStore>(context);
            return AlertDialog(
              title: Text('Select Account'),
              content: Container(
                width: 500,
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DropdownButtonFormField<ActorStore>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      hint: Text("Choose an account to use"),
                      isExpanded: true,
                      isDense: true,
                      value: null,
                      items: store.accounts.values
                          .map((account) => DropdownMenuItem<ActorStore>(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(account.actorName),
                                    Chip(
                                      backgroundColor: Theme.of(context)
                                          .chipTheme
                                          .selectedColor,
                                      label: Text(
                                        account.actorType.actorTypeName(),
                                      ),
                                    ),
                                  ],
                                ),
                                value: account,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          store.accountChanged = false;
                          store.selectedAccount = value;
                          store.accountChanged = true;
                        });
                      },
                    ),
                    AccountQr(),
                  ],
                ),
              ),
              actions: <Widget>[
                OutlineButton(
                  child: SizedBox(
                    width: 150,
                    height: 50,
                    child: Center(
                      child: Text('Disconnect'),
                    ),
                  ),
                  onPressed: () {
                    store.selectedAccount = ActorStore();
                    Navigator.of(context).pop();
                    final snackBar = SnackBar(
                      content: Text('Your account is now disconnected'),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.maybeOf(context).showSnackBar(snackBar);
                  },
                ),
                OutlineButton(
                  child: SizedBox(
                    width: 150,
                    height: 50,
                    child: Center(
                      child: Text('OK'),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    final snackBar = SnackBar(
                      content: Text(
                          'You are now transacting as "${store.selectedAccount.actorName}" at address: ${store.selectedAccount.address.hex}'),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.maybeOf(context).showSnackBar(snackBar);
                  },
                ),
              ],
            );
          },
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
