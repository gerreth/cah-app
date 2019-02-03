import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

import '../provider/game_communication.dart';
import '../provider/game_provider.dart';
import '../widgets/atoms/button.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controller = TextEditingController();
  GameCommunication _game = GameCommunication();

  void joinGame(String name) {
    _game.send('join', name);
    Navigator.pushNamed(context, '/start');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Cards',
                      style: theme.textTheme.headline,
                    ),
                    Text(
                      'Against',
                      style: theme.textTheme.headline,
                    ),
                    Text(
                      'Humanity',
                      style: theme.textTheme.headline,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'A party game',
                      style: theme.textTheme.title,
                    ),
                    Text(
                      'for horrible people',
                      style: theme.textTheme.title,
                    ),
                  ],
                ),
                SizedBox(height: 48),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(0.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(
                        Radius.circular(0.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(0.0),
                      ),
                    ),

                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Enter your name',
                    contentPadding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                    // icon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 48),
                Button(
                  text: 'Start',
                  onTap: () => joinGame(controller.text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
