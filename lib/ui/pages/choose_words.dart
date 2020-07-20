import 'package:flutter/material.dart';
import 'package:grocery_helper/ui/widgets/text_dialog.dart';
import 'package:grocery_helper/ui/widgets/word_button.dart';

class ChooseWordsPage extends StatefulWidget {
  ChooseWordsPage({Key key, this.title, this.words}) : super(key: key);

  final String title;
  final List<String> words;

  @override
  _ChooseWordsPageState createState() => _ChooseWordsPageState();
}

class _ChooseWordsPageState extends State<ChooseWordsPage> {
  final customTextController = TextEditingController();

  List<String> selected = [];

  _returnResult(BuildContext context, result) {
    Navigator.pop(context, result);
  }

  _doCustomText() {
    customTextController.text = this.selected.join(" ");

    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return TextInputDialog(
          title: Text('Custom Text'),
          hint: 'Enter Text',
          controller: customTextController,
          onFinished: (String text) {
            _returnResult(context, text);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> wordsFound = [];
    for (final word in this.widget.words) {
      wordsFound.add(
        WordButton(
          onPressed: () {
            setState(() {
              if (this.selected.contains(word)) {
                this.selected.remove(word);
              } else {
                this.selected.add(word);
              }
            });
          },
          word: word,
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _doCustomText();
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                _returnResult(context, this.selected.join(" "));
              },
            )
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        '${this.selected}',
                        textScaleFactor: 2.0,
                      ),
                    ],
                  ),
                ],
              ),
              Flexible(
                fit: FlexFit.loose,
                child: SingleChildScrollView(
                  child: Wrap(
                    children: <Widget>[...wordsFound],
                  ),
                ),
              ),
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  @override
  void dispose() {
    customTextController.dispose();
    super.dispose();
  }
}
