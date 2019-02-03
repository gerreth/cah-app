import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import './game_communication.dart';
import '../models/player_model.dart';

class GameBloc {
  GameCommunication _game = GameCommunication();
  final _cards = BehaviorSubject<List<dynamic>>();
  final _players = BehaviorSubject<List<PlayerModel>>();
  final _round = BehaviorSubject<int>();

  Sink<List<dynamic>> get cardsSink => _cards.sink;
  Sink<List<PlayerModel>> get playersSink => _players.sink;
  Sink<int> get roundSink => _round.sink;

  Stream<List<dynamic>> get cardsStream => _cards.stream;
  Stream<List<PlayerModel>> get playersStream => _players.stream;
  Stream<int> get roundStream => _round.stream;

  Stream<bool> get isDealer {
    return playersStream.transform(
      StreamTransformer<List<PlayerModel>, bool>.fromHandlers(
        handleData: (players, sink) {
          PlayerModel player =
              players.firstWhere((player) => player.id == _game.playerID);

          if (player.dealer) {
            sink.add(true);
          } else {
            sink.add(false);
          }
        },
      ),
    );
  }

  Stream<bool> get allowSubmit {
    return playersStream.transform(
      StreamTransformer<List<PlayerModel>, bool>.fromHandlers(
        handleData: (players, sink) {
          int numOfPlayers =
              players.where((player) => player.name != null).length;

          if (numOfPlayers > 1) {
            sink.add(true);
          } else {
            sink.add(false);
          }
        },
      ),
    );
  }

  void nextRound(int round) {}

  dispose() {
    _cards.close();
    _players.close();
    _round.close();
  }
}

class GameProvider extends InheritedWidget {
  final bloc = GameBloc();

  GameProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static GameBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(GameProvider) as GameProvider)
        .bloc;
  }
}
