import 'package:beacontcc/src/blocs/sotore/store_bloc.dart';
import 'package:flutter/material.dart';

class StoreBlocProvider extends InheritedWidget{
  final bloc = StoreBloc();

  StoreBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static StoreBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<StoreBlocProvider>()).bloc;
  }
}