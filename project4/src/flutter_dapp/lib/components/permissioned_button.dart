import 'package:flutter/material.dart';
import 'package:flutter_dapp/contract/account_store.dart';
import 'package:flutter_dapp/data/actor.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class PermissionedButton extends StatelessWidget {
  final ActorType requiredRole;
  final Function action;
  final String buttonText;
  final bool disableCondition;
  final unassignedRoleAllowed;

  PermissionedButton(
      {@required this.requiredRole,
      @required this.action,
      @required this.buttonText,
      this.unassignedRoleAllowed = false,
      this.disableCondition = false})
      : assert(requiredRole != null),
        assert(action != null),
        assert(buttonText != null),
        assert(disableCondition != null);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountStore>(context);
    return Observer(
      builder: (context) => Tooltip(
        message: requiredRole.warningMessage(),
        child: FlatButton(
          color: Colors.blueAccent,
          onPressed: (store.selectedActor == null ||
                  store.selectedActor.actorType != requiredRole ||
                  disableCondition ||
                  !(unassignedRoleAllowed &&
                      store.selectedActor.actorType == ActorType.Unassigned))
              ? null
              : action,
          child: Text(buttonText),
        ),
      ),
    );
  }
}
