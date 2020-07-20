import 'package:flutter/material.dart';
import 'package:grocery_helper/io/model/item.dart';
import 'package:grocery_helper/io/storage/item.dart';
import 'package:grocery_helper/ui/pages/items/view_item.dart';
import 'package:grocery_helper/ui/widgets/drawer.dart';

import 'new_item.dart';

class ItemsPage extends StatefulWidget {
  ItemsPage({Key key, this.items, this.category}) : super(key: key);

  final List<Item> items;
  final String category;

  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  List<Item> _items = <Item>[];

  void _redirectItemForm(Item item) async {
    await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (BuildContext context) => new ViewItemPage(item: item),
      ),
    );
    _refreshItems();
  }

  void _redirectAddNew() {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (BuildContext context) => new NewItemPage(),
      ),
    );
  }

  void _getAllItems() {
    ItemJsonStorage().readAll().then((results) {
      setState(() {
        this._items = [];
        results.forEach((id, item) => this._items.add(item));
        this._items.sort((Item a, Item b) =>
            a.dateLastModified.compareTo(b.dateLastModified));
      });
    });
  }

  void _refreshItems() {
    if (widget.items != null) {
      setState(() {
        this._items = widget.items;
      });
    } else {
      _getAllItems();
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.category == null
            ? Text('All Items')
            : Text('Items - ${widget.category}'),
      ),
      drawer: widget.items == null ? DrawerWidget(selectedIndex: 1) : null,
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('${_items[index].itemName}'),
            subtitle: Text('${_items[index].genericItemName}'),
            trailing: Text('${_items[index].price} / ${_items[index].size}'),
            onTap: () {
              _redirectItemForm(_items[index]);
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _redirectAddNew,
        tooltip: 'Add new item',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
