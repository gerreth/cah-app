import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

import '../models/player_model.dart';
import '../provider/game_communication.dart';
import '../provider/game_provider.dart';
import '../blocs/player_bloc.dart';

class Game extends StatefulWidget {
  Game({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  GameBloc _bloc;
  PlayerBloc _playerBloc;

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
    _playerBloc = PlayerBloc();
  }

  void _update(message) {
    switch (message["action"]) {
      case 'players_list':
        List<PlayerModel> playerModels = message['data'].map<PlayerModel>(
          (dynamic player) {
            return PlayerModel.fromJson(player);
          },
        ).toList();

        _bloc.playersSink.add(playerModels);

        PlayerModel thisPlayer =
            playerModels.firstWhere((player) => player.id == game.playerID);
        _playerBloc.cardsSink.add(thisPlayer.cards);

        if (playerModels.length < 2) {
          Navigator.pop(context);
        }
        break;
      case 'next_round':
        _bloc.roundSink.add(message["data"]);
        break;
    }
  }

  void nextRound() {
    game.send('next_round', '1');
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
      drawer: SizedBox(
        width: 200,
        child: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the Drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              StreamBuilder(
                stream: _bloc.playersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<PlayerModel>> snapshot) {
                  // TODO: handle waiting and error
                  if (snapshot.hasError) return Text('error');
                  if (snapshot.data == null) return Text('waiting');

                  snapshot.data.sort((a, b) => b.points.compareTo(a.points));

                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data
                        .where((player) => player.name != null)
                        .map<Widget>(
                          (player) => Text(
                                '${player.name}: ${player.points} ${(player.dealer) ? ' dealer' : ''}',
                                style: TextStyle(color: Colors.black),
                              ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          // height: MediaQuery.of(context).size.height,
          // width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: StreamBuilder(
            stream: _bloc.isDealer,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              // TODO: handle waiting and error
              if (snapshot.hasError) return Text('error');
              if (snapshot.data == null) return Text('waiting');

              if (snapshot.data) {
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            margin: EdgeInsets.all(20),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Lorem ipsum dolor ____________ sit amet at balbd',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          RaisedButton(
                            child: Text(
                              'next round',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: nextRound,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                bool accepted = false;
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            margin: EdgeInsets.all(20),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Lorem ipsum dolor ____________ sit amet at balbd',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DragTarget(
                            builder: (context, List<String> candidateData,
                                rejectedData) {
                              return accepted ? Container() : Container();
                            },
                            onWillAccept: (data) {
                              return true;
                            },
                            onAccept: (data) {
                              accepted = true;
                            },
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.all(10.0),
                      sliver: Cards(_playerBloc.cardsStream),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class Cards extends StatelessWidget {
  final Stream stream;

  Cards(this.stream);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // TODO: handle waiting and error
        if (snapshot.hasError)
          return SliverGrid.count(
            crossAxisCount: 1,
            children: List.generate(
              1,
              (index) {
                return Text('error');
              },
            ),
          );
        if (snapshot.data == null)
          return SliverGrid.count(
            crossAxisCount: 1,
            children: List.generate(
              1,
              (index) {
                return Text('waiting');
              },
            ),
          );
        ;

        return SliverGrid.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this would produce 2 rows.
          crossAxisCount: 2,
          children: List.generate(
            6,
            (index) {
              dynamic card = snapshot.data[index];

              return Draggable(
                feedback: Card(
                  id: card['id'],
                  text: card['text'],
                ),
                childWhenDragging: Container(),
                child: Card(
                  id: card['id'],
                  text: card['text'],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class Card extends StatelessWidget {
  final Key key;
  final int id;
  final String text;

  Card({this.key, @required this.id, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.body2;

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Text(
        text,
        style: style.copyWith(color: Colors.black),
      ),
    );
  }
}
