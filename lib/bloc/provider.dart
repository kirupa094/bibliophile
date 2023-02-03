import 'package:flutter/material.dart';
import 'bloc.dart';
export 'bloc.dart';

class Provider extends InheritedWidget {
  final Bloc bloc;

  Provider({Key? key, required Widget child})
      : bloc = Bloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;
  // bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static Bloc? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()?.bloc;
  }
}
