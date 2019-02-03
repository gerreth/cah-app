import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PlayerBloc {
  final _cards = BehaviorSubject<List<dynamic>>();

  Sink<List<dynamic>> get cardsSink => _cards.sink;

  Stream<List<dynamic>> get cardsStream => _cards.stream;

  dispose() {
    _cards.close();
  }
}

class PlayerProvider extends InheritedWidget {
  final bloc = PlayerBloc();

  PlayerProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static PlayerBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(PlayerProvider)
            as PlayerProvider)
        .bloc;
  }
}
