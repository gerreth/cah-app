import './card_model.dart';

class PlayerModel {
  final List<CardModel> cards;
  final bool dealer;
  final String id;
  final String name;
  final int points;

  PlayerModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        cards = parsedJson['cards'].map<CardModel>(
          (dynamic player) {
            return CardModel.fromJson(player);
          },
        ).toList(),
        dealer = parsedJson['dealer'],
        name = parsedJson['name'],
        points = parsedJson['points'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "cards": cards,
      "id": id,
      "name": name,
      "points": points,
      "dealer": dealer,
    };
  }

  @override
  String toString() => 'Player: $name - $id - $points - $dealer';
}
