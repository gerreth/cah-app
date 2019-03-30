import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';

import '../models/card_model.dart';

class RoundBloc {
  final _blackCard = BehaviorSubject<CardModel>();
  final _chosenCard = BehaviorSubject<List<Map<String, dynamic>>>();
  final _round = BehaviorSubject<int>();

  Sink<CardModel> get blackCardSink => _blackCard.sink;
  Sink<int> get roundSink => _round.sink;
  Sink<List<Map<String, dynamic>>> get chosenCardsSink => _chosenCard.sink;

  Stream<CardModel> get blackCardStream => _blackCard.stream;
  Stream<int> get roundStream => _round.stream;
  Stream<List<Map<String, dynamic>>> get chosenCardStream => _chosenCard.stream;

  void addBlackCard(dynamic data) {
    CardModel card = CardModel.fromJson(data);

    blackCardSink.add(card);
  }

  void addChosenCards(dynamic data) {
    List<Map<String, dynamic>> cards = data.map<Map<String, dynamic>>(
      (dynamic item) {
        return {
          'id': item['id'],
          'card': CardModel.fromJson(
              json.decode(item['card'])), // TOOD: Fix decoding here
        };
      },
    ).toList();

    chosenCardsSink.add(cards);
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
