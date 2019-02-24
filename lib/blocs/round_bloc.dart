import 'dart:async';
import 'package:rxdart/rxdart.dart';

import '../models/card_model.dart';

class RoundBloc {
  final _blackCard = BehaviorSubject<CardModel>();
  final _chosenCard = BehaviorSubject<Map<String, CardModel>>();
  final _round = BehaviorSubject<int>();

  Sink<CardModel> get blackCardSink => _blackCard.sink;
  Sink<int> get roundSink => _round.sink;
  Sink<Map<String, CardModel>> get chosenCardSink => _chosenCard.sink;

  Stream<CardModel> get blackCardStream => _blackCard.stream;
  Stream<int> get roundStream => _round.stream;
  Stream<Map<String, CardModel>> get chosenCardStream => _chosenCard.stream;

  void addBlackCard(dynamic data) {
    CardModel card = CardModel.fromJson(data);

    blackCardSink.add(card);
  }

  void addChosenCards(dynamic data) {
    data.map((key, value) {
      print(key);
      print(value);
    });
  }

  void nextRound(int round) {
    roundSink.add(round);
  }

  dispose() {
    _blackCard.close();
    _chosenCard.close();
    _round.close();
  }
}
