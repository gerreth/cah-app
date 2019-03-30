import 'package:flutter/material.dart';

import '../atoms.dart' show CustomBackButton;

class DefaultTemplate extends StatelessWidget {
  DefaultTemplate({this.child}) : super();

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: Navigator.of(context).canPop()
      //     ? PreferredSize(
      //         preferredSize: Size.fromHeight(40.0), // here the desired height
      //         child: AppBar(
      //           automaticallyImplyLeading: false,
      //           backgroundColor: Colors.black,
      //           title: Row(
      //             children: <Widget>[
      //               CustomBackButton(
      //                 onTap: () => Navigator.of(context)
      //                     .pushNamedAndRemoveUntil(
      //                         '/', (Route<dynamic> route) => false),
      //               ),
      //               Text('Foo'),
      //             ],
      //           ),
      //         ),
      //       )
      //     : null,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Navigator.of(context).canPop()
                ? PreferredSize(
                    preferredSize:
                        Size.fromHeight(40.0), // here the desired height
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.black,
                      title: Row(
                        children: <Widget>[
                          CustomBackButton(
                            onTap: () => Navigator.of(context)
                                .pushNamedAndRemoveUntil(
                                    '/', (Route<dynamic> route) => false),
                          ),
                          Text('Foo'),
                        ],
                      ),
                    ),
                  )
                : null
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.black,
            child: child,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          ),
        ),
      ),
    );
  }
}
