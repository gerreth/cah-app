import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../blocs/game_bloc.dart';
import '../blocs/round_bloc.dart';
import '../blocs/player_bloc.dart';
import '../models/card_model.dart';
import '../provider/game_communication.dart';
import '../provider/game_provider.dart';
import './game/views.dart' show GameView;

class Game extends StatefulWidget {
  Game({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  GameBloc _gameBloc;
  RoundBloc _roundBloc = RoundBloc();
  PlayerBloc _playerBloc = PlayerBloc();

  @override
  void initState() {
    super.initState();
    game.addListener(_update);
  }

  @override
  void dispose() {
    game.addListener(_update);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gameBloc = GameProvider.of(context);
  }

  void _update(message) {
    switch (message['action']) {
      case 'game_next_round':
        _playerBloc.chosenCardSink.add(null);
        _roundBloc.chosenCardsSink.add(null);
        _gameBloc.addPlayers(message['data']['players_list']);
        _roundBloc.addBlackCard(message['data']['card']);
        _roundBloc.nextRound(message['data']['round']);
        break;
      case 'game_chosen_cards':
        _roundBloc.addChosenCards(message['data']);
        break;
    }
  }

  void chooseCard(CardModel card) {
    _playerBloc.chosenCardSink.add(card);
  }

  void submitChosenCard() {
    _playerBloc.submit();
  }

  void leaveGame() {
    game.send('leave', game.playerID);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void nextRound() {
    game.send('game_next_round', '1');
  }

  void sendCard(CardModel card) {
    game.send('send_card', jsonEncode(card.toMap()));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return GameView(
      gameBloc: _gameBloc,
      onBack: leaveGame,
      onChooseCard: chooseCard,
      onSubmitChosenCard: submitChosenCard,
      onNextRound: nextRound,
      playerBloc: _playerBloc,
      roundBloc: _roundBloc,
    );
  }
}
