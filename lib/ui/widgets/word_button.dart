import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WordButton extends StatefulWidget {
  WordButton({Key key, @required this.onPressed, this.word}) : super(key: key);

  final String word;
  final Function onPressed;

  @override
  _WordButtonState createState() => _WordButtonState();
}

class _WordButtonState extends State<WordButton> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.5),
      child: RaisedButton(
        onPressed: () {
          setState(() {
            this.isSelected = !this.isSelected;
          });
          widget.onPressed();
        },
        color: this.isSelected
            ? Theme.of(context).accentColor
            : Theme.of(context).buttonColor,
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Text(
            widget.word,
            textScaleFactor: 1.1,
          ),
        ),
      ),
    );
  }
}
