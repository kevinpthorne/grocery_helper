import 'package:flutter/material.dart';
import 'package:grocery_helper/io/model/item.dart';
import 'package:grocery_helper/io/storage/item.dart';
import 'package:grocery_helper/ui/forms/item.dart';
import 'package:grocery_helper/ui/pages/items/list_item.dart';
import 'package:grocery_helper/ui/widgets/drawer.dart';
import 'package:grocery_helper/ui/widgets/item_stat.dart';

import 'choose_words.dart';
import 'items/new_item.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, List<Item>> _itemsByCategory = {};

  void _redirectAddNew() {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (BuildContext context) => new NewItemPage(),
      ),
    );
  }

  void _redirectCategoryList(String category) async {
    var results = await ItemJsonStorage().readAllByCategory();
    List<Item> items = results[category];
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (BuildContext context) => new ItemsPage(
          items: items,
          category: category,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    ItemJsonStorage().readAllByCategory().then((result) {
      setState(() {
        _itemsByCategory = result;
      });
    });
  }

  List<Widget> buildItemStats() {
    List<Widget> allItemStats = [];
    this._itemsByCategory.forEach((String category, List<Item> items) {
      Map<String, List<Item>> itemsByCategoryByUnit =
          ItemJsonStorage.sortByUnit(items);
      itemsByCategoryByUnit.forEach((String uom, List<Item> itemsByUnit) {
        allItemStats.add(ItemStat(
          categoryName: '${category} per ${uom}',
          itemCount: itemsByUnit.length,
          averagePricePer: ItemJsonStorage.meanItemPrices(itemsByUnit),
          uom: uom,
          onTap: () async {
            await _redirectCategoryList(category);
          },
        ));
      });
    });
    return allItemStats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: DrawerWidget(selectedIndex: 0),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: buildItemStats(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _redirectAddNew,
        tooltip: 'Add new item',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
