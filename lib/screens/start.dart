import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

import '../blocs/game_bloc.dart';
import '../models/player_model.dart';
import '../provider/game_communication.dart';
import '../provider/game_provider.dart';
import '../widgets/atoms/button.dart';

class Start extends StatefulWidget {
  Start({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  GameBloc _gameBloc;

  void leaveGame() {
    game.send('leave', game.playerID);
    Navigator.pop(context);
  }

  void startGame() {
    game.send('start_game', '');
  }

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
    switch (message["action"]) {
      case 'player_cards':
        _gameBloc.addCards(message["data"]);
        break;
      case 'players_list':
        _gameBloc.addPlayers(message["data"], context);
        break;
      case 'game_start':
        _gameBloc.roundSink.add(1);
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

    return StartTemplate(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          BackButton(
            onTap: onBack,
          ),
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

class BackButton extends StatelessWidget {
  BackButton({Key key, this.onTap}) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: 48,
        width: 48,
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          color: Colors.black,
          child: InkResponse(
            borderRadius: BorderRadius.circular(24.0),
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            highlightColor: Colors.white.withOpacity(0.2),
            splashColor: Colors.white.withOpacity(0.2),
            onTap: onTap,
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class StartTemplate extends StatelessWidget {
  StartTemplate({this.child}) : super();

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.black,
            child: child,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          ),
        ),
      ),
    );
  }
}
