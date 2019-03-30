import 'dart:async';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';

import '../provider/game_communication.dart';
import '../models/card_model.dart';
import '../models/player_model.dart';

class GameBloc {
  final _chosenCard = BehaviorSubject<dynamic>();
  final _chosenWinner = BehaviorSubject<String>();
  final _player = BehaviorSubject<PlayerModel>();
  final _players = BehaviorSubject<List<PlayerModel>>();

  Sink<dynamic> get chosenCardSink => _chosenCard.sink;
  Sink<String> get chosenWinnerSink => _chosenWinner.sink;
  Sink<PlayerModel> get playerSink => _player.sink;
  Sink<List<PlayerModel>> get playersSink => _players.sink;

  Stream<dynamic> get chosenCardStream => _chosenCard.stream;
  Stream<String> get chosenWinnerStream => _chosenWinner.stream;
  Stream<PlayerModel> get playerStream => _player.stream;
  Stream<List<PlayerModel>> get playersStream => _players.stream;

  void addPlayers(dynamic data) {
    List<PlayerModel> players = data
        .map<PlayerModel>((dynamic player) => PlayerModel.fromJson(player))
        .toList();

    PlayerModel player =
        players.firstWhere((player) => player.id == game.playerID);

    playerSink.add(player);
    playersSink.add(players);
  }

  void submitPlayerCard() {
    dynamic card = _chosenCard.value;

    game.send('player_send_card', jsonEncode(card['card'].toMap()));
  }

  void submitDealerCard() {
    dynamic card = _chosenCard.value;

    if (card == null) {
      game.send('game_next_round', '1');
    } else {
      game.send(
        'dealer_send_card',
        jsonEncode({'id': card['id'], 'card': card['card'].toMap()}),
      );
    }
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

  Stream<bool> get playerAllowSubmit {
    return chosenCardStream.transform(
      StreamTransformer<dynamic, bool>.fromHandlers(
        handleData: (card, sink) {
          if (card != null) {
            sink.add(true);
          } else {
            sink.add(false);
          }
        },
      ),
    );
  }

  Stream<bool> get dealerAllowSubmit {
    return chosenCardStream.transform(
      StreamTransformer<dynamic, bool>.fromHandlers(
        handleData: (card, sink) {
          if (card != null) {
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
    _chosenCard.close();
    _chosenWinner.close();
    _player.close();
    _players.close();
  }
}
