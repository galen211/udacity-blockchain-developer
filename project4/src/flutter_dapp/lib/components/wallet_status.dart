import 'package:flutter/material.dart';
import 'package:flutter_dapp/contract/account_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class WalletStatus extends StatelessWidget {
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
                store.showAccountSelection(context);
              },
            ),
          ],
        ),
      );
    });
  }
}
