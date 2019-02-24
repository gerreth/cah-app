import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens/game_new.dart';
import 'screens/home.dart';
import 'screens/start.dart';

Route routes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      print('/');
      return CupertinoPageRoute(
        builder: (context) {
          return Home();
        },
      );
    case '/start':
      print('/start');
      return MaterialPageRoute(
        builder: (context) {
          return Start();
        },
      );
    case '/game':
      print('/game');
      return MaterialPageRoute(
        builder: (context) {
          return Game();
        },
      );
    default:
      print('/default');
      return CupertinoPageRoute(
        builder: (context) {
          return Home();
        },
      );
  }
}
