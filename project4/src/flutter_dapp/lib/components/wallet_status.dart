import 'package:flutter/material.dart';
import 'package:flutter_dapp/contract/contract_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class WalletStatus extends StatefulWidget {
  @override
  _WalletStatusState createState() => _WalletStatusState();
}

class _WalletStatusState extends State<WalletStatus> {
  Future<void> _showMyDialog() async {
    final store = Provider.of<ContractStore>(context, listen: false);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Flight Surety'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You are connected to MetaMask'),
                Text('Your account address is: ${store.connectedAccount}'),
                Text(
                    'The app contract address is : ${store.appContractAddress}'),
                Text('Your available accounts are: ${store.metamaskAccounts}'),
                Text(
                    'Your account balance is: ${store.accountBalance} ETH'), // could add copy to clipboard
                Text(
                    'To change your wallet, please use Metamask to select a different account'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ContractStore>(context);
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
                store.isAccountConnected
                    ? _showMyDialog()
                    : store.connectMetamask();
              },
            ),
          ],
        ),
      );
    });
  }
}
