import './card_model.dart';

class PlayerModel {
  // final dynamic card;
  final CardModel card;
  final List<CardModel> cards;
  final bool dealer;
  final String id;
  final String name;
  final int points;

  PlayerModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        cards = parsedJson['cards'] != null
            ? parsedJson['cards']
                .map<CardModel>(
                  (card) => CardModel.fromJson(card),
                )
                .toList()
            : [CardModel.empty()],
        card = parsedJson['card'] != null
            ? CardModel.fromJson(parsedJson['card'])
            : CardModel.empty(),
        dealer = parsedJson['dealer'] ?? false,
        name = parsedJson['name'],
        points = parsedJson['points'] ?? 0;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "cards": cards,
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
