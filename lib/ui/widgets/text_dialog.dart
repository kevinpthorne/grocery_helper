import 'package:flutter/material.dart';

class TextInputDialog extends StatelessWidget {
  TextInputDialog(
      {Key key,
      @required this.title,
      @required this.hint,
      @required this.onFinished,
      TextEditingController controller})
      : super(key: key) {
    this._textEditingController = controller ?? new TextEditingController();
  }

  final Widget title;
  final String hint;
  final Function onFinished;
  TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: this.title,
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: 'Enter text'),
              controller: _textEditingController,
            )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Use'),
          onPressed: () {
            Navigator.pop(context); // close dialog
            this.onFinished(_textEditingController.text);
          },
        ),
      ],
    );
  }
}
