import 'package:flutter/material.dart';
import 'package:flutter_dapp/stores/account_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountStore>(context);
    return Observer(builder: (context) {
      _controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
      );
      _animation = Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(_controller);
      _controller.forward();
      return FadeTransition(
        opacity: _animation,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).canvasColor.withOpacity(0.90),
          ),
          child: store.selectedPage,
        ),
      );
    });
  }
}
