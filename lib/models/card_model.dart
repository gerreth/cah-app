class CardModel {
  final int cardId;
  final String cardText;

  CardModel.fromJson(Map<String, dynamic> parsedJson)
      : cardId = parsedJson['cardId'],
        cardText = parsedJson['cardText'];

  CardModel.empty()
      : cardId = null,
        cardText = null;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "cardId": cardId,
      "cardText": cardText,
    };
  }

  @override
  String toString() => 'Card: $cardText - $cardId';
}
