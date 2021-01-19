import 'package:flutter/material.dart';
import 'package:flutter_dapp/data/enums.dart';
import 'package:flutter_dapp/stores/account_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class AccountWarning extends StatelessWidget {
  final ActorType requiredRole;

  AccountWarning(this.requiredRole);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountStore>(context);

    return Observer(builder: (context) {
      if (store.selectedAccount == null) {
        return Text(
          'You must be connected to an account in order to transact',
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(color: Theme.of(context).errorColor),
        );
      } else if (store.selectedAccount.actorType != requiredRole) {
        return Text(
          '${requiredRole.actorTypeName()} account is required.',
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(color: Theme.of(context).errorColor),
        );
      } else {
        return Container();
      }
    });
  }
}
