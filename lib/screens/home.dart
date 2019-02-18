import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../blocs/game_bloc.dart';
import '../provider/game_communication.dart';
import '../provider/game_provider.dart';
import '../widgets/atoms/button.dart';
import '../widgets/widgets.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controller = TextEditingController();
  // GameCommunication _game = GameCommunication();
  GameBloc _bloc;

  void joinGame() {
    print('home -> join');
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
    _bloc = GameProvider.of(context);
  }

  void _update(message) {
    switch (message["action"]) {
      case 'joined':
        print('home -> joined');
        Navigator.pushNamed(context, '/start');
        break;
      case 'players_list':
        print('home -> players_list');
        _bloc.addPlayers(message["data"], context);
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

    return HomeTemplate(
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
          ),
          SizedBox(height: 48),
          Button(
            text: 'Start',
            onTap: joinGame,
          ),
        ],
      ),
    );
  }
}

class HomeTemplate extends StatelessWidget {
  HomeTemplate({this.child}) : super();

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: child,
          ),
        ),
      ),
    );
  }
}
