import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../blocs/game_bloc.dart';
import '../../models/player_model.dart';
import '../../widgets/atoms.dart' show Button;
import './views.dart';

class PlayerContainer extends StatefulWidget {
  PlayerContainer({
    Key key,
    @required this.chooseCard,
    @required this.submitChosenCard,
    @required this.gameBloc,
    @required this.player,
  });

  final GameBloc gameBloc;
  final PlayerModel player;
  final Function chooseCard;
  final Function submitChosenCard;

  @override
  _PlayerContainerState createState() => _PlayerContainerState();
}

class _PlayerContainerState extends State<PlayerContainer> {
  bool submitted = false;

  void _onTap() {
    widget.submitChosenCard();
    setState(() {
      submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return submitted
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PlayerView(
                player: widget.player,
                chooseCard: widget.chooseCard,
                submitChosenCard: widget.submitChosenCard,
              ),
              StreamBuilder(
                stream: widget.gameBloc.playerAllowSubmit,
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Text('error');

                  print(snapshot.data);

                  return Button(
                    text: snapshot.data == null ? 'Karte wählen' : 'Abschicken',
                    onTap: snapshot.data == null ? null : _onTap,
                  );
                },
              ),
            ],
          );
  }
}

class PlayerView extends StatelessWidget {
  PlayerView({
    Key key,
    @required this.chooseCard,
    @required this.submitChosenCard,
    @required this.player,
  }) : super(key: key);

  final PlayerModel player;
  final Function chooseCard;
  final Function submitChosenCard;

  List<Widget> renderCards() {
    return player.cards.map(
      (card) {
        return CustomCard(
          onTap: chooseCard,
          card: {'card': card},
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      padding: EdgeInsets.symmetric(vertical: 16),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: renderCards(),
    );
  }
}
