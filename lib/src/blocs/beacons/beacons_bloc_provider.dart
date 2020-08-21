import 'package:beacontcc/src/blocs/beacon_promotions/beacon_promotions_bloc.dart';
import 'package:flutter/material.dart';

import 'beacons_bloc.dart';

class BeaconsBlocProvider extends InheritedWidget{
  final bloc = BeaconsBloc();

  BeaconsBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static BeaconsBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<BeaconsBlocProvider>()).bloc;
  }
}