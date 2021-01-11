import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dapp/components/airlines.dart';
import 'package:flutter_dapp/components/oracles.dart';
import 'package:flutter_dapp/components/passengers.dart';
import 'package:flutter_dapp/components/scenario.dart';
import 'package:flutter_dapp/contract/account_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ViewCarousel extends StatelessWidget {
  final List<Widget> pages = [
    SetupPage(),
    AirlinePage(),
    PassengerPage(),
    OraclePage()
  ];

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountStore>(context);
    return Observer(
      builder: (context) => Container(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 600,
                    autoPlay: false,
                    pageSnapping: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 200),
                    autoPlayCurve: Curves.easeInExpo,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                  ),
                  items: pages,
                  carouselController: store.carouselController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
