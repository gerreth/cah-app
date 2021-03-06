import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../blocs/game_bloc.dart';
import '../provider/game_communication.dart';
import '../provider/game_provider.dart';
import '../widgets/atoms/button.dart';
import '../widgets/templates/default_template.dart';
import '../widgets/widgets.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controller = TextEditingController();
  GameBloc _gameBloc;

  void joinGame() {
    game.send('join', controller.text);
    Navigator.pushNamed(context, '/start');
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
      case 'players_list':
        _gameBloc.addPlayers(message["data"]);
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

    return DefaultTemplate(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CustomHeadline('Cards'),
              CustomHeadline('Against'),
              CustomHeadline('Humanity'),
              SizedBox(height: 16),
              CustomTitle('A party game'),
              CustomTitle('for horrible people'),
            ],
          ),
          SizedBox(height: 48),
          InputTextField(
            controller: controller,
            hintText: 'Enter your name',
            onSubmitted: (value) => joinGame(),
          ),
          SizedBox(height: 48),
          Button(
            text: 'Start',
            onTap: joinGame,
          ),
          SizedBox(height: 48),
          Button(
            text: 'Reset',
            onTap: () {
              game.reset();
            },
          ),
        ],
      ),
    );
  }
}
