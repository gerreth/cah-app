import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../blocs/game_bloc.dart';
import '../../models/card_model.dart';
import '../../models/player_model.dart';

import '../../blocs/player_bloc.dart';
import '../../widgets/atoms/button.dart';
import '../../widgets/atoms/custom_back_button.dart';
import '../../widgets/templates/default_template.dart';

class GameView extends StatelessWidget {
  GameView({
    Key key,
    @required this.gameBloc,
    @required this.onBack,
    @required this.onChooseCard,
    @required this.onSubmitChosenCard,
    @required this.onNextRound,
    @required this.playerBloc,
  }) : super(key: key);
  final Function onBack;
  final Function onChooseCard;
  final Function onSubmitChosenCard;
  final Function onNextRound;
  final GameBloc gameBloc;
  final PlayerBloc playerBloc;

  Widget renderBlackCard(BuildContext context, CardModel card) {
    List<String> text = card.cardText.split('___________');

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.width / 2,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: StreamBuilder(
            stream: playerBloc.chosenCardStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text('error');

              String fillText = snapshot.data?.cardText ?? '___________';

              return RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: text[0],
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
                      text: text[1],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTemplate(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: CustomBackButton(
              onTap: onBack,
            ),
          ),
          StreamBuilder(
            stream: gameBloc.blackCardStream,
            builder: (context, AsyncSnapshot<CardModel> snapshot) {
              if (snapshot.hasError) return Text('error');
              if (snapshot.data == null) return Text('waiting');

              CardModel card = snapshot.data;

              return renderBlackCard(context, card);
            },
          ),
          StreamBuilder(
            stream: gameBloc.playerStream,
            builder: (context, AsyncSnapshot<PlayerModel> snapshot) {
              if (snapshot.hasError) return Text('error');
              if (snapshot.data == null) return Text('waiting');

              PlayerModel player = snapshot.data;

              if (player.dealer) {
                return DealerView(
                  nextRound: onNextRound,
                );
              } else {
                return PlayerView(
                    player: player,
                    chooseCard: onChooseCard,
                    submitChosenCard: onSubmitChosenCard);
              }
            },
          ),
        ],
      ),
    );
  }
}

class DealerView extends StatelessWidget {
  DealerView({Key key, @required this.nextRound}) : super(key: key);

  final Function nextRound;

  @override
  Widget build(BuildContext context) {
    return Button(
      text: 'TEST',
      onTap: nextRound,
    );
  }
}

class PlayerView extends StatelessWidget {
  PlayerView({
    Key key,
    this.chooseCard,
    this.submitChosenCard,
    this.player,
  }) : super(key: key);

  final PlayerModel player;
  final Function chooseCard;
  final Function submitChosenCard;

  List<Widget> renderCards() {
    return player.cards.map(
      (card) {
        return Material(
          child: InkWell(
            onTap: () {
              chooseCard(card);
            },
            highlightColor: Colors.green,
            splashColor: Colors.green,
            child: Container(
              child: Text(
                card.cardText,
                style: TextStyle(fontSize: 14),
              ),
              padding: EdgeInsets.all(16),
            ),
          ),
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          padding: EdgeInsets.symmetric(vertical: 16),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: renderCards(),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Button(
            text: 'Karte wählen',
            onTap: submitChosenCard,
          ),
        ),
      ],
    );
  }
}