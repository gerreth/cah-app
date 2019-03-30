import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../blocs/game_bloc.dart';
import '../blocs/round_bloc.dart';
import '../models/card_model.dart';
import '../provider/game_communication.dart';
import '../provider/game_provider.dart';
import '../widgets/templates/default_template.dart';

import './game/views.dart' show BlackCardView;
import './game/dealer_view.dart';
import './game/player_view.dart';

import '../models/player_model.dart';

class Game extends StatefulWidget {
  Game({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  GameBloc _gameBloc;
  RoundBloc _roundBloc;
  Timer _timer;
  final counter = ValueNotifier(3);

  @override
  void initState() {
    super.initState();
    game.addListener(_update);
    _startTimer();
  }

  @override
  void dispose() {
    game.addListener(_update);
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gameBloc = GameProvider.of(context);
    _roundBloc = RoundProvider.of(context);
  }

  void _startTimer() {
    counter.value = 3;
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (counter.value < 1) {
        timer.cancel();
      } else {
        counter.value -= 1;
      }
    });
  }

  void _update(message) {
    switch (message['action']) {
      case 'game_next_round':
        _gameBloc.chosenCardSink.add(null);
        _roundBloc.chosenCardsSink.add(null);
        _gameBloc.addPlayers(message['data']['players_list']);
        _roundBloc.addBlackCard(message['data']['card']);
        _roundBloc.nextRound(message['data']['round']);
        _startTimer();
        break;
      case 'game_chosen_cards':
        _roundBloc.addChosenCards(message['data']);
        break;
    }
  }

  void _chooseCard(dynamic card) {
    print(card);
    _gameBloc.chosenCardSink.add(card);
  }

  void _submitChosenCard() {
    _gameBloc.submitPlayerCard();
  }

  void _submitDealerCard() {
    _gameBloc.submitDealerCard();
  }

  void leaveGame() {
    game.send('leave', game.playerID);
    Navigator.pop(context);
    Navigator.pop(context);
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

    TextStyle headline = Theme.of(context).textTheme.headline;

    return DefaultTemplate(
      child: ValueListenableBuilder(
        valueListenable: counter,
        builder: (context, value, child) {
          if (value > 0)
            return Container(
              constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height - 40 - 36 - 20,
                width: MediaQuery.of(context).size.width,
              ),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 60.0,
                  width: 60.0,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      color: Colors.white,
                    ),
                    child: Text(
                      value.toString(),
                      style: headline.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              BlackCardView(
                gameBloc: _gameBloc,
                roundBloc: _roundBloc,
              ),
              StreamBuilder(
                stream: _gameBloc.playerStream,
                builder: (context, AsyncSnapshot<PlayerModel> snapshot) {
                  if (snapshot.hasError) return Text('error');
                  if (snapshot.data == null) return Text('waiting');

                  PlayerModel player = snapshot.data;

                  if (player.dealer) {
                    return DealerView(
                      nextRound: _submitDealerCard,
                      chooseCard: _chooseCard,
                      gameBloc: _gameBloc,
                      roundBloc: _roundBloc,
                    );
                  } else {
                    return PlayerContainer(
                      gameBloc: _gameBloc,
                      player: player,
                      chooseCard: _chooseCard,
                      submitChosenCard: _submitChosenCard,
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
