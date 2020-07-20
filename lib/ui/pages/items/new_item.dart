import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:grocery_helper/io/model/item.dart';
import 'package:grocery_helper/ui/forms/item.dart';
import 'package:grocery_helper/ui/pages/choose_words.dart';

class NewItemPage extends StatefulWidget {
  NewItemPage({Key key}) : super(key: key);

  @override
  _NewItemPageState createState() => _NewItemPageState();
}

class _NewItemPageState extends State<NewItemPage> {
  List<String> words = [];

  final _formUiKey = GlobalKey<ItemFormState>();

  @override
  void initState() {
    super.initState();
    FlutterMobileVision.start().then((x) async {
      _readText();
    });
  }

  void _readText() async {
    setState(() {});

    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        flash: false,
        autoFocus: true,
        multiple: true,
        showText: true,
        waitTap: true,
        fps: 2.0,
      );
    } on Exception {
      texts.add(new OcrText('!Failed to recognize text.!'));
    }

    setState(() {
      texts.forEach((element) {
        List<String> splitValues = element.value.split(" ");
        splitValues.forEach((value) {
          this.words.add(value);
        });
      });
    });

    await _fillForm();
  }

  //TODO clean this up
  _fillForm() async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseWordsPage(
          title: 'Generic Product Name',
          words: words,
        ),
      ),
    );
    setState(() {
      _formUiKey.currentState.genericItemNameController.text = result;
    });

    result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseWordsPage(
          title: 'Specific Product Name',
          words: words,
        ),
      ),
    );
    setState(() {
      _formUiKey.currentState.itemNameController.text = result;
    });

    result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseWordsPage(
          title: 'Price',
          words: words,
        ),
      ),
    );
    setState(() {
      _formUiKey.currentState.priceController.text = result;
    });

    result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseWordsPage(
          title: 'Size',
          words: words,
        ),
      ),
    );
    setState(() {
      _formUiKey.currentState.sizeController.text = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Item'),
      ),
      body: ItemForm(
        key: _formUiKey,
        item: Item.empty(),
      ),
    );
  }
}
