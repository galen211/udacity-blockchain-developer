import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_dapp/components/scenario.dart';
import 'package:flutter_dapp/components/airlines.dart';
import 'package:flutter_dapp/components/oracles.dart';
import 'package:flutter_dapp/components/passengers.dart';
import 'package:flutter_dapp/contract/contract_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ViewCarousel extends StatelessWidget {
  List<Widget> pages = [
    SetupPage(),
    AirlinePage(),
    PassengerPage(),
    OraclePage()
  ];

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ContractStore>(context);
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
                    autoPlayAnimationDuration: Duration(milliseconds: 500),
                    autoPlayCurve: Curves.linear,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                  ),
                  items: pages,
                  carouselController: store.carouselController,
                  // items: pages.map((pageSelection) {
                  //   return Builder(
                  //     builder: (BuildContext context) {
                  //       return Container(
                  //         width: MediaQuery.of(context).size.width,
                  //         margin: EdgeInsets.symmetric(horizontal: 20.0),
                  //         decoration: BoxDecoration(color: Colors.black87),
                  //         child: pageSelection,
                  //       );
                  //     },
                  //   );
                  // }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
