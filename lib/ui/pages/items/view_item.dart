import 'package:flutter/material.dart';
import 'package:grocery_helper/io/model/item.dart';
import 'package:grocery_helper/ui/forms/item.dart';

class ViewItemPage extends StatelessWidget {
  final Item item;

  const ViewItemPage({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item'),
      ),
      body: ItemForm(
        item: this.item,
      ),
    );
  }

}