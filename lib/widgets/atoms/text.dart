import 'package:flutter/material.dart';

class CustomBody1 extends StatelessWidget {
  CustomBody1(this.text)
      : assert(text != null),
        super();

  final String text;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.body1,
    );
  }
}

class CustomBody2 extends StatelessWidget {
  CustomBody2(this.text)
      : assert(text != null),
        super();

  final String text;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.body2,
    );
  }
}
