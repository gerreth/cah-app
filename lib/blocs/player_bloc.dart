import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../models/card_model.dart';

class PlayerBloc {
  final _cards = BehaviorSubject<List<CardModel>>();
  final _chosenCard = BehaviorSubject<CardModel>();

  Sink<List<CardModel>> get cardsSink => _cards.sink;
  Sink<CardModel> get chosenCardSink => _chosenCard.sink;

  Stream<List<CardModel>> get cardsStream => _cards.stream;
  Stream<CardModel> get chosenCardStream => _chosenCard.stream;

  dispose() {
    _cards.close();
    _chosenCard.close();
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
