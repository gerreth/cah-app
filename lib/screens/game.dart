// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/rendering.dart';

// import '../blocs/game_bloc.dart';
// import '../models/card_model.dart';
// import '../models/player_model.dart';
// import '../provider/game_communication.dart';
// import '../provider/game_provider.dart';
// import '../blocs/player_bloc.dart';

// class Game extends StatefulWidget {
//   Game({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _GameState createState() => _GameState();
// }

// class _GameState extends State<Game> {
//   GameBloc _bloc;
//   PlayerBloc _playerBloc;

//   @override
//   void initState() {
//     super.initState();

//     game.addListener(_update);
//   }

//   @override
//   void dispose() {
//     game.addListener(_update);
//     super.dispose();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _bloc = GameProvider.of(context);
//     _playerBloc = PlayerBloc();
//   }

//   void _update(message) {
//     switch (message["action"]) {
//       case 'player_cards':
//         print('player_cards');
//         break;
//       case 'players_list':
//         print('players_list');
//         _bloc.addPlayers(message["data"]);
//         break;
//       case 'next_round':
//         _bloc.roundSink.add(message["data"]);
//         break;
//     }
//   }

//   void nextRound() {
//     game.send('next_round', '1');
//   }

//   void sendCard(CardModel card) {
//     game.send('send_card', jsonEncode(card.toMap()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//       SystemUiOverlayStyle(
//         statusBarColor: Colors.white,
//         statusBarIconBrightness: Brightness.dark,
//       ),
//     );

//     return Scaffold(
//       bottomNavigationBar: BottomAppBar(
//         child: StreamBuilder(
//           stream: _playerBloc.chosenCardStream,
//           builder: (BuildContext context, AsyncSnapshot<CardModel> snapshot) {
//             if (snapshot.hasError) return Text('error');
//             if (snapshot.data == null) return Text('Please select');

//             return Container(
//               child: FlatButton(
//                 child: Text('Send'),
//                 onPressed: () {
//                   sendCard(snapshot.data);
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//       drawer: SizedBox(
//         width: 200,
//         child: Drawer(
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: <Widget>[
//               DrawerHeader(
//                 child: Text('Drawer Header'),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                 ),
//               ),
//               StreamBuilder(
//                 stream: _bloc.playersStream,
//                 builder: (BuildContext context,
//                     AsyncSnapshot<List<PlayerModel>> snapshot) {
//                   // TODO: handle waiting and error
//                   if (snapshot.hasError)
//                     return SliverGrid.count(
//                       crossAxisCount: 1,
//                       children: List.generate(
//                         1,
//                         (index) {
//                           return Text('error');
//                         },
//                       ),
//                     );
//                   if (snapshot.data == null)
//                     return SliverGrid.count(
//                       crossAxisCount: 1,
//                       children: List.generate(
//                         1,
//                         (index) {
//                           return Text('waiting');
//                         },
//                       ),
//                     );
//                   ;

//                   snapshot.data.sort((a, b) => b.points.compareTo(a.points));

//                   return ListView(
//                     shrinkWrap: true,
//                     children: snapshot.data
//                         .where((player) => player.name != null)
//                         .map<Widget>(
//                           (player) => Text(
//                                 '${player.name}: ${player.points} ${(player.dealer) ? ' dealer' : ''}',
//                                 style: TextStyle(color: Colors.black),
//                               ),
//                         )
//                         .toList(),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Container(
//           color: Colors.black,
//           // height: MediaQuery.of(context).size.height,
//           // width: MediaQuery.of(context).size.width,
//           padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//           child: StreamBuilder(
//             stream: _bloc.isDealer,
//             builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//               // TODO: handle waiting and error
//               if (snapshot.hasError) return Text('error');
//               if (snapshot.data == null) return Text('waiting');

//               if (snapshot.data) {
//                 return CustomScrollView(
//                   slivers: <Widget>[
//                     SliverList(
//                       delegate: SliverChildListDelegate(
//                         [
//                           Container(
//                             margin: EdgeInsets.all(20),
//                             padding: EdgeInsets.all(10),
//                             child: Text(
//                               'Lorem ipsum dolor ____________ sit amet at balbd',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                           // SliverPadding(
//                           //   padding: EdgeInsets.all(10.0),
//                           //   sliver: StreamBuilder(
//                           //     stream: _bloc.chosenCardsStream,
//                           //     builder: (BuildContext context,
//                           //         AsyncSnapshot snapshot) {
//                           //       if (snapshot.hasError) return Text('error');
//                           //       if (snapshot.data == null)
//                           //         return Text('waiting');

//                           //       print(snapshot.data);

//                           //       return SliverGrid.count(
//                           //         // Create a grid with 2 columns. If you change the scrollDirection to
//                           //         // horizontal, this would produce 2 rows.
//                           //         crossAxisCount: 2,
//                           //         children: List.generate(
//                           //           snapshot.data.length,
//                           //           (index) {
//                           //             CardModel card = snapshot.data[index];

//                           //             return Draggable(
//                           //               data: card,
//                           //               feedback: Card(card: card),
//                           //               childWhenDragging: Container(),
//                           //               child: Card(card: card),
//                           //             );
//                           //           },
//                           //         ),
//                           //       );
//                           //     },
//                           //   ),
//                           // ),
//                           StreamBuilder(
//                             builder: (BuildContext context,
//                                 AsyncSnapshot<List<CardModel>> snapshot) {
//                               if (snapshot.data == null) return Text('null');
//                               return Column(
//                                 children: snapshot.data
//                                     .map(
//                                       (card) => Text(
//                                             card.cardText,
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                     )
//                                     .toList(),
//                               );
//                             },
//                             stream: _bloc.chosenCardsStream,
//                           ),
//                           RaisedButton(
//                             child: Text(
//                               'next round',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             onPressed: nextRound,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               } else {
//                 CardModel accepted;
//                 return CustomScrollView(
//                   slivers: <Widget>[
//                     SliverPersistentHeader(
//                       floating: true,
//                       pinned: true,
//                       delegate: PersistentHeaderDelegate(
//                         child: Container(
//                           color: Colors.black,
//                           padding: EdgeInsets.all(20),
//                           child: Column(
//                             children: <Widget>[
//                               Text(
//                                 'Lorem ipsum dolor ',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                               DragTarget(
//                                 builder: (context,
//                                     List<CardModel> candidateData,
//                                     rejectedData) {
//                                   return Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: accepted != null
//                                         ? Text(
//                                             accepted.cardText,
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               decoration:
//                                                   TextDecoration.underline,
//                                             ),
//                                           )
//                                         : Text(
//                                             '___________',
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               decorationColor: Colors.red,
//                                             ),
//                                           ),
//                                   );
//                                 },
//                                 onWillAccept: (CardModel data) {
//                                   if (data.cardId > 0) {
//                                     return true;
//                                   } else {
//                                     return false;
//                                   }
//                                 },
//                                 onAccept: (CardModel data) {
//                                   accepted = data;
//                                   _playerBloc.chosenCardSink.add(data);
//                                 },
//                               ),
//                               Text(
//                                 ' sit amet at balbd',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ],
//                           ),
//                         ),
//                         maxExtent: 140,
//                         minExtent: 120,
//                       ),
//                     ),
//                     SliverPadding(
//                       padding: EdgeInsets.all(10.0),
//                       sliver: Cards(_bloc.cardsStream),
//                     ),
//                   ],
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Cards extends StatelessWidget {
//   final Stream<List<CardModel>> stream;

//   Cards(this.stream);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: stream,
//       builder: (BuildContext context, AsyncSnapshot<List<CardModel>> snapshot) {
//         // TODO: handle waiting and error
//         if (snapshot.hasError)
//           return SliverGrid.count(
//             crossAxisCount: 1,
//             children: List.generate(
//               1,
//               (index) {
//                 return Text('error');
//               },
//             ),
//           );
//         if (snapshot.data == null)
//           return SliverGrid.count(
//             crossAxisCount: 1,
//             children: List.generate(
//               1,
//               (index) {
//                 return Text('waiting');
//               },
//             ),
//           );
//         ;

//         return SliverGrid.count(
//           // Create a grid with 2 columns. If you change the scrollDirection to
//           // horizontal, this would produce 2 rows.
//           crossAxisCount: 2,
//           children: List.generate(
//             6,
//             (index) {
//               CardModel card = snapshot.data[index];

//               return Draggable(
//                 data: card,
//                 feedback: Card(card: card),
//                 childWhenDragging: Container(),
//                 child: Card(card: card),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// class Card extends StatelessWidget {
//   final Key key;
//   final CardModel card;

//   Card({
//     this.key,
//     @required this.card,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     TextStyle style = Theme.of(context).textTheme.body2;

//     return Container(
//       margin: EdgeInsets.all(10),
//       padding: EdgeInsets.all(10),
//       color: Colors.white,
//       child: Text(
//         card.cardText,
//         style: style.copyWith(color: Colors.black),
//       ),
//     );
//   }
// }

// class PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
//   final Widget child;
//   final double minExtent;
//   final double maxExtent;

//   PersistentHeaderDelegate({
//     @required this.child,
//     @required this.minExtent,
//     @required this.maxExtent,
//   }) : super();

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     return child;
//   }

//   @override
//   bool shouldRebuild(PersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }
