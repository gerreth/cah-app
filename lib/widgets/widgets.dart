import 'package:flutter/material.dart';

class Wrapper extends InheritedModel<String> {
  const Wrapper(
    this.one,
    this.two,
    Widget child,
  ) : super(child: child);

  final String one;
  final String two;

  @override
  bool updateShouldNotify(Wrapper oldWidget) {
    return one != oldWidget.one || two != oldWidget.two;
  }

  @override
  bool updateShouldNotifyDependent(
      Wrapper oldWidget, Set<String> dependencies) {
    if (dependencies.contains('one') && one != oldWidget.one) {
      return true;
    }
    if (dependencies.contains('two') && two != oldWidget.two) {
      return true;
    }

    return false;
  }
}

class InputTextField extends StatelessWidget {
  InputTextField({
    @required this.controller,
    @required this.hintText,
    this.onSubmitted,
  }) : super();

  final TextEditingController controller;
  final String hintText;
  final Function onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        contentPadding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      ),
    );
  }
}

class CustomTitle extends StatelessWidget {
  CustomTitle(this.text)
      : assert(text != null),
        super();

  final String text;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.title,
    );
  }
}

class CustomHeadline extends StatelessWidget {
  CustomHeadline(this.text)
      : assert(text != null),
        super();

  final String text;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.headline,
    );
  }
}

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
