class CardModel {
  final int id;
  final String text;

  CardModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        text = parsedJson['text'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "text": text,
    };
  }

  @override
  String toString() => 'Card: $text - $id';
}
