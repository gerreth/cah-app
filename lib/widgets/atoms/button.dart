import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Button extends StatelessWidget {
  final Function onTap;
  final String text;

  Button({this.onTap, this.text});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Material(
      child: InkResponse(
        highlightShape: BoxShape.rectangle,
        highlightColor: Colors.black26,
        splashColor: Colors.black12,
        radius: 140,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.0),
          // color: Colors.white,
          child: Text(
            text,
            style: theme.textTheme.body1,
          ),
        ),
      ),
    );
  }
}
