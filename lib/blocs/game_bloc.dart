import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../provider/game_communication.dart';
import '../models/card_model.dart';
import '../models/player_model.dart';

class GameBloc {
  GameCommunication _game = GameCommunication();

  final _chosenCards = BehaviorSubject<List<CardModel>>();
  final _cards = BehaviorSubject<List<CardModel>>();
  final _player = BehaviorSubject<PlayerModel>();
  final _players = BehaviorSubject<List<PlayerModel>>();
  final _round = BehaviorSubject<int>();

  Sink<List<CardModel>> get cardsSink => _cards.sink;
  Sink<List<CardModel>> get chosenCardsSink => _chosenCards.sink;
  Sink<PlayerModel> get playerSink => _player.sink;
  Sink<List<PlayerModel>> get playersSink => _players.sink;
  Sink<int> get roundSink => _round.sink;

  Stream<List<CardModel>> get cardsStream => _cards.stream;
  Stream<List<CardModel>> get chosenCardsStream => _chosenCards.stream;
  Stream<List<PlayerModel>> get playersStream => _players.stream;
  Stream<PlayerModel> get playerStream => _player.stream;
  Stream<int> get roundStream => _round.stream;

  void addChosenCards(dynamic data) {
    List<CardModel> cards = data
        .map<PlayerModel>((dynamic player) => PlayerModel.fromJson(player))
        .where((PlayerModel player) => !player.dealer)
        .map<CardModel>((PlayerModel player) => player.card)
        .toList();

    chosenCardsSink.add(cards);
  }

  void addCards(dynamic data) {
    List<CardModel> cards = data
        .map<CardModel>((dynamic card) => CardModel.fromJson(card))
        .toList();

    cardsSink.add(cards);
  }

  void addPlayers(dynamic data) {
    List<PlayerModel> players = data
        .map<PlayerModel>((dynamic player) => PlayerModel.fromJson(player))
        .toList();

    PlayerModel player =
        players.firstWhere((player) => player.id == game.playerID);

    playerSink.add(player);
    playersSink.add(players);
  }

  Stream<bool> get isDealer {
    return playersStream.transform(
      StreamTransformer<List<PlayerModel>, bool>.fromHandlers(
        handleData: (players, sink) {
          PlayerModel player =
              players.firstWhere((player) => player.id == _game.playerID);

          sink.add(player.dealer);
        },
      ),
    );
  }

  Stream<bool> get allowSubmit {
    return playersStream.transform(
      StreamTransformer<List<PlayerModel>, bool>.fromHandlers(
        handleData: (players, sink) {
          if (players.length > 1) {
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
    _chosenCards.close();
    _cards.close();
    _player.close();
    _players.close();
    _round.close();
  }
}
