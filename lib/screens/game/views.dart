import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../blocs/game_bloc.dart';
import '../../blocs/round_bloc.dart';
import '../../models/card_model.dart';
import '../../widgets/atoms.dart' show CustomBody2;

// class GameView extend

class BlackCardView extends StatelessWidget {
  BlackCardView({
    Key key,
    @required this.gameBloc,
    @required this.roundBloc,
  }) : super(key: key);
  final RoundBloc roundBloc;
  final GameBloc gameBloc;

  Widget renderBlackCard(BuildContext context, dynamic card) {
    List<String> cardText = card.cardText.split('___________');

    return StreamBuilder(
      stream: gameBloc.chosenCardStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('error');

        String fillText = snapshot.data != null
            ? snapshot.data['card'].cardText ?? '___________'
            : '___________';

        return RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: cardText[0],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: fillText,
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
              TextSpan(
                text: cardText[1],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.width / 2,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: StreamBuilder(
            initialData: roundBloc.blackCard,
            stream: roundBloc.blackCardStream,
            builder: (context, AsyncSnapshot<CardModel> snapshot) {
              if (snapshot.hasError) return Text('error');
              if (snapshot.data == null) return Text('waiting');

              CardModel card = snapshot.data;

              return renderBlackCard(context, card);
            },
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  CustomCard({Key key, this.card, this.onTap}) : super(key: key);

  final dynamic card;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          print(card);
          onTap(card);
        },
        highlightColor: Colors.green,
        splashColor: Colors.green,
        child: Container(
          child: CustomBody2(
            card['card'].cardText,
          ),
          padding: EdgeInsets.all(16),
        ),
      ),
    );
  }
}
