import 'package:flutter/material.dart';

import 'routes.dart';
import 'theme.dart';
import 'blocs/round_bloc.dart';
import 'provider/game_provider.dart';

main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoundProvider(
      child: GameProvider(
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
          theme: theme,
          onGenerateRoute: routes,
        ),
      ),
    );
  }
}
