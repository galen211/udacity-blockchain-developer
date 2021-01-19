import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dapp/stores/account_store.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AccountQr extends StatefulWidget {
  @override
  _AccountQrState createState() => _AccountQrState();
}

class _AccountQrState extends State<AccountQr> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountStore>(context);
    return Column(
      children: [
        Container(
          height: 250,
          width: 250,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: QrImage(
              padding: EdgeInsets.all(16),
              backgroundColor: Colors.white,
              data: store.selectedAccount.address.hex,
              version: QrVersions.auto,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton.icon(
            icon: FaIcon(FontAwesomeIcons.clipboard),
            label: Text(store.selectedAccount.address.hex),
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: store.selectedAccount.address.hex),
              );
            },
          ),
        ),
      ],
    );
  }
}
