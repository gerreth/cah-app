import './card_model.dart';

class PlayerModel {
  // final dynamic card;
  final CardModel card;
  // final List<CardModel> cards;
  final bool dealer;
  final String id;
  final String name;
  final int points;

  PlayerModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        // card = parsedJson['card'],
        card = parsedJson['card'] != null
            ? CardModel.fromJson(parsedJson['card'])
            : CardModel.empty(),
        // cards = parsedJson['cards'].map<CardModel>(
        //   (dynamic player) {
        //     return CardModel.fromJson(player);
        //   },
        // ).toList(),
        dealer = parsedJson['dealer'],
        name = parsedJson['name'],
        points = parsedJson['points'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // "cards": cards,
      "card": card,
      "id": id,
      "name": name,
      "points": points,
      "dealer": dealer,
    };
  }

  @override
  String toString() => 'Player: $name - $id - $points - $dealer - $card';
}
