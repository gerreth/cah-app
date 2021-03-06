import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

import '../blocs/game_bloc.dart';
import '../blocs/round_bloc.dart';
import '../models/player_model.dart';
import '../provider/game_communication.dart';
import '../provider/game_provider.dart';
import '../widgets/atoms/button.dart';
import '../widgets/templates/default_template.dart';

class Start extends StatefulWidget {
  Start({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  GameBloc _gameBloc;
  RoundBloc _roundBloc;

  void leaveGame() {
    game.send('leave', game.playerID);
    Navigator.pop(context);
  }

  void startGame() {
    game.send('game_start', '');
  }

  @override
  void initState() {
    super.initState();
    game.addListener(_update);
  }

  @override
  void dispose() {
    game.removeListener(_update);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gameBloc = GameProvider.of(context);
    _roundBloc = RoundProvider.of(context);
  }

  void _update(message) {
    switch (message['action']) {
      case 'players_list':
        _gameBloc.addPlayers(message['data']);
        break;
      case 'game_start':
        print('game_start');
        _gameBloc.addPlayers(message['data']['players_list']);
        _roundBloc.nextRound(message['data']['round']);
        _roundBloc.addBlackCard(message['data']['card']);
        continue game_has_started;
      game_has_started:
      case 'game_has_started':
        Navigator.pushNamed(context, '/game');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StartView(
      bloc: _gameBloc,
      onBack: () => leaveGame(),
      onStart: () => startGame(),
    );
  }
}

class StartView extends StatelessWidget {
  StartView({Key key, this.bloc, this.onBack, this.onStart}) : super(key: key);

  final GameBloc bloc;
  final Function onBack;
  final Function onStart;

  Widget renderPlayers(List<PlayerModel> players) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ListView(
        shrinkWrap: true,
        children: players.map(
          (player) {
            return Text(
              player.name,
              style: TextStyle(color: Colors.white),
            );
          },
        ).toList(),
      ),
    );
  }

  Widget renderButton(bool allowSubmit) {
    String text = allowSubmit ? 'Starten' : 'Warten';
    Function onTap = allowSubmit ? onStart : () {};

    return Button(
      text: text,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return DefaultTemplate(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          StreamBuilder(
            stream: bloc.playersStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<PlayerModel>> snapshot) {
              // TODO: handle waiting and error
              if (snapshot.hasError) return Text('error');
              if (snapshot.data == null) return Text('waiting');

              return renderPlayers(snapshot.data);
            },
          ),
          StreamBuilder(
            stream: bloc.allowSubmit,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              // TODO: handle waiting and error
              if (snapshot.hasError) return Text('error');
              if (snapshot.data == null) return Text('waiting');

              return renderButton(snapshot.data);
            },
          ),
        ],
      ),
    );
  }
}
