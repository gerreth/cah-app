import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../blocs/game_bloc.dart';
import '../models/card_model.dart';
import '../models/player_model.dart';
import '../provider/game_communication.dart';
import '../provider/game_provider.dart';
import '../blocs/player_bloc.dart';
import '../widgets/atoms/button.dart';
import '../widgets/atoms/custom_back_button.dart';
import '../widgets/templates/default_template.dart';

class Game extends StatefulWidget {
  Game({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  GameBloc _gameBloc;
  PlayerBloc _playerBloc;

  @override
  void initState() {
    super.initState();
    _playerBloc = PlayerBloc();

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
      case 'player_cards':
        _gameBloc.addCards(message['data']);
        break;
      case 'players_list':
        _gameBloc.addChosenCards(message['data']);
        _gameBloc.addPlayers(message['data']);
        break;
      case 'game_next_round':
        _gameBloc.roundSink.add(message['data']['round']);
        _gameBloc.addPlayers(message['data']['players_list']);
        break;
    }
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
      nextRound: nextRound,
      onBack: leaveGame,
    );
  }
}

class GameView extends StatelessWidget {
  GameView({
    Key key,
    @required this.onBack,
    @required this.gameBloc,
    @required this.nextRound,
  }) : super(key: key);
  final Function onBack;
  final GameBloc gameBloc;
  final Function nextRound;

  @override
  Widget build(BuildContext context) {
    return DefaultTemplate(
      child: Column(
        children: <Widget>[
          CustomBackButton(
            onTap: onBack,
          ),
          StreamBuilder(
            initialData: 1,
            stream: gameBloc.roundStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text('error');
              if (snapshot.data == null) return Text('waiting');

              return StreamBuilder(
                stream: gameBloc.playerStream,
                builder: (context, AsyncSnapshot<PlayerModel> snapshot) {
                  if (snapshot.hasError) return Text('error');
                  if (snapshot.data == null) return Text('waiting');
                  print(snapshot.data.dealer);

                  if (snapshot.data.dealer) {
                    return DealerView(
                      nextRound: nextRound,
                    );
                  } else {
                    return PlayerView();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class DealerView extends StatelessWidget {
  DealerView({Key key, @required this.nextRound}) : super(key: key);

  final Function nextRound;

  @override
  Widget build(BuildContext context) {
    return Button(
      text: 'TEST',
      onTap: nextRound,
    );
  }
}

class PlayerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'TEST',
    );
  }
}
