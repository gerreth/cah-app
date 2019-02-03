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
  GameBloc _bloc;

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
    _bloc = GameProvider.of(context);
  }

  void _update(message) {
    switch (message["action"]) {
      case 'player_cards':
        print('player_cards');
        _bloc.addCards(message["data"]);
        break;
      case 'players_list':
        _bloc.addPlayers(message["data"], context);
        break;
      case 'game_start':
        _bloc.roundSink.add(1);
        continue game_has_started;
      game_has_started:
      case 'game_has_started':
        Navigator.pushNamed(context, '/game');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 40,
                width: 40,
                child: Material(
                  color: Colors.black,
                  child: InkResponse(
                    highlightShape: BoxShape.circle,
                    highlightColor: Colors.white70,
                    splashColor: Colors.white54,
                    onTap: () => leaveGame(),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              StreamBuilder(
                stream: _bloc.playersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<PlayerModel>> snapshot) {
                  // TODO: handle waiting and error
                  if (snapshot.hasError) return Text('error');
                  if (snapshot.data == null) return Text('waiting');

                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data
                        .where((player) => player.name != null)
                        .map<Widget>(
                          (player) => Text(
                                player.name,
                                style: TextStyle(color: Colors.white),
                              ),
                        )
                        .toList(),
                  );
                },
              ),
              StreamBuilder(
                stream: _bloc.allowSubmit,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  // TODO: handle waiting and error
                  if (snapshot.hasError) return Text('error');
                  if (snapshot.data == null) return Text('waiting');

                  return snapshot.data
                      ? Button(
                          text: 'Starten',
                          onTap: () {
                            startGame();
                          },
                        )
                      : Button(
                          text: 'wait',
                          onTap: () {},
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
