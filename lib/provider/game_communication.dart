import 'dart:convert';

import 'package:flutter/foundation.dart';
import './web_socket_notifictions.dart';

GameCommunication game = new GameCommunication();

class GameCommunication {
  static final GameCommunication _game = new GameCommunication._internal();

  String _playerName = "";
  String _playerID = "";

  factory GameCommunication() {
    return _game;
  }

  GameCommunication._internal() {
    sockets.initCommunication();
    sockets.addListener(_onMessageReceived);
  }

  String get playerName => _playerName;
  String get playerID => _playerID;

  _onMessageReceived(serverMessage) {
    Map message = json.decode(serverMessage);

    switch (message["action"]) {
      case 'connect':
        _playerID = message["data"];
        break;
      default:
        _listeners.forEach((Function callback) {
          callback(message);
        });
        break;
    }
  }

  reset() {
    sockets.reset();
    sockets.initCommunication();
    sockets.addListener(_onMessageReceived);
  }

  send(String action, String data) {
    switch (action) {
      case 'join':
        _playerName = data;
        break;
      case 'leave':
        _playerName = '';
        break;
    }

    sockets.send(json.encode({"action": action, "data": data}));
  }

  ObserverList<Function> _listeners = new ObserverList<Function>();

  addListener(Function callback) {
    _listeners.add(callback);
  }

  removeListener(Function callback) {
    _listeners.remove(callback);
  }
}
