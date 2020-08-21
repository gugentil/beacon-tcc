import 'package:beacontcc/src/blocs/beacon_promotions/beacon_promotions_bloc.dart';
import 'package:flutter/material.dart';

class BeaconPromotionsBlocProvider extends InheritedWidget{
  final bloc = BeaconPromotionsBloc();

  BeaconPromotionsBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static BeaconPromotionsBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<BeaconPromotionsBlocProvider>()).bloc;
  }
}