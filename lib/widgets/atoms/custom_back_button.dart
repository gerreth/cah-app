import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  CustomBackButton({Key key, this.onTap}) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: 48,
        width: 48,
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          color: Colors.black,
          child: InkResponse(
            borderRadius: BorderRadius.circular(24.0),
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            highlightColor: Colors.white.withOpacity(0.2),
            splashColor: Colors.white.withOpacity(0.2),
            onTap: onTap,
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
