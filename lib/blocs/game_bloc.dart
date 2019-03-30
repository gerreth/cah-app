import 'dart:async';
import 'package:rxdart/rxdart.dart';

import '../provider/game_communication.dart';
import '../models/card_model.dart';
import '../models/player_model.dart';

class GameBloc {
  GameCommunication _game = GameCommunication();

  final _chosenWinningCard = BehaviorSubject<CardModel>();
  final _player = BehaviorSubject<PlayerModel>();
  final _players = BehaviorSubject<List<PlayerModel>>();

  Sink<PlayerModel> get playerSink => _player.sink;
  Sink<List<PlayerModel>> get playersSink => _players.sink;
  Sink<CardModel> get chosenWinningCardSink => _chosenWinningCard.sink;

  Stream<PlayerModel> get playerStream => _player.stream;
  Stream<List<PlayerModel>> get playersStream => _players.stream;
  Stream<CardModel> get chosenWinningCardStream => _chosenWinningCard.stream;

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
    _chosenWinningCard.close();
    _player.close();
    _players.close();
  }
}
