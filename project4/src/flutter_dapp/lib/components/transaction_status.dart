import 'package:flutter/material.dart';
import 'package:flutter_dapp/stores/contract_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class TransactionStatus extends StatefulWidget {
  @override
  _TransactionStatusState createState() => _TransactionStatusState();
}

class _TransactionStatusState extends State<TransactionStatus> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ContractStore>(context);
    return Observer(
      builder: (_) => AnimatedOpacity(
        child: const LinearProgressIndicator(),
        opacity: store.isTransactionPending ? 1 : 0,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
