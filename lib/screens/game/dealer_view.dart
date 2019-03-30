import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../blocs/game_bloc.dart';
import '../../blocs/round_bloc.dart';
import '../../models/card_model.dart';
import '../../widgets/atoms.dart' show Button;
import './views.dart';

class DealerView extends StatelessWidget {
  DealerView({
    Key key,
    @required this.nextRound,
    @required this.chooseCard,
    @required this.gameBloc,
    @required this.roundBloc,
  }) : super(key: key);

  final Function nextRound;
  final Function(dynamic) chooseCard;
  final GameBloc gameBloc;
  final RoundBloc roundBloc;

  void _onTap(dynamic card) {
    chooseCard(card);
    print(card);
  }

  @override
  Widget build(BuildContext context) {
    print('view');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder(
          stream: roundBloc.chosenCardStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('error');
            if (snapshot.data == null) return Text('waiting');

            return GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              padding: EdgeInsets.symmetric(vertical: 16),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: snapshot.data.map<Widget>((dynamic item) {
                return CustomCard(
                  onTap: _onTap,
                  card: item,
                );
              }).toList(),
            );
          },
        ),
        StreamBuilder(
          stream: gameBloc.dealerAllowSubmit,
          builder: (context, snapshot) {
            print(snapshot);
            if (snapshot.hasError) return Text('error');
            if (snapshot.data == null) return Text('waiting');

            return Button(
              text: 'Gewinner auswählen',
              onTap: nextRound,
            );
          },
        ),
      ],
    );
  }
}
