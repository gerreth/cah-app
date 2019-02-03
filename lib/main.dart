import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'provider/game_provider.dart';
import 'screens/game.dart';
import 'screens/home.dart';
import 'screens/start.dart';

main() async {
  runApp(MyApp());
}

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

ThemeData theme = ThemeData(
  primarySwatch: Colors.blue,
  primaryTextTheme: TextTheme(),
  textTheme: TextTheme(
    headline: TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.w600,
    ),
    title: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w300,
    ),
    body1: TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GameProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        theme: theme,
        onGenerateRoute: routes,
      ),
    );
  }
}
