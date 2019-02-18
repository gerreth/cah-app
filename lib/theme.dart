import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  primarySwatch: Colors.blue,
  primaryTextTheme: TextTheme(),
  textTheme: TextTheme(
    headline: TextStyle(
      color: Colors.white,
      fontSize: 32,
      fontWeight: FontWeight.w600,
    ),
    title: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w300,
    ),
    body1: TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ),
);
