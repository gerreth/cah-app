import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../models/card_model.dart';
import '../provider/game_communication.dart';

class PlayerBloc {
  final _chosenCard = BehaviorSubject<CardModel>();

  Sink<CardModel> get chosenCardSink => _chosenCard.sink;

  Stream<CardModel> get chosenCardStream => _chosenCard.stream;

  void submit() {
    CardModel card = _chosenCard.value;

    game.send('player_send_card', jsonEncode(card.toMap()));
  }

  dispose() {
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
