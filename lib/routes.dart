import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens/game_new.dart';
import 'screens/home.dart';
import 'screens/start.dart';

Route routes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return CupertinoPageRoute(
        builder: (context) {
          return Home();
        },
      );
    case '/start':
      return MaterialPageRoute(
        builder: (context) {
          return Start();
        },
      );
    case '/game':
      return MaterialPageRoute(
        builder: (context) {
          return Game();
        },
      );
    default:
      return CupertinoPageRoute(
        builder: (context) {
          return Home();
        },
      );
  }
}
