import 'package:flutter/material.dart';

import '../blocs/game_bloc.dart';

class GameProvider extends InheritedWidget {
  final bloc = GameBloc();

  GameProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static GameBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(GameProvider) as GameProvider)
        .bloc;
  }
}
