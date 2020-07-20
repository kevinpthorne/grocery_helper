import 'package:grocery_helper/io/model/item.dart';

import '../model_storage.dart';

class ItemJsonStorage extends JsonFileStorage<Item> {
  @override
  String get localFileName => "items.json";

  @override
  Item buildModel(Map<String, dynamic> data) => Item.fromJson(data);

  Future<Map<String, List<Item>>> readAllByCategory() async {
    Map<String, Item> allItems = await this.readAll();
    Map<String, List<Item>> itemsByCategory = <String, List<Item>>{};

    allItems.forEach((String id, Item item) {
      if(itemsByCategory.containsKey(item.categoryKey)) {
        itemsByCategory[item.categoryKey].add(item);
      } else {
        itemsByCategory[item.categoryKey] = <Item>[item];
      }
    });

    return itemsByCategory;
  }

  //TODO should this be static?
  static Map<String, List<Item>> sortByUnit(List<Item> items) {
    Map<String, List<Item>> itemsByUnit = <String, List<Item>>{};

    items.forEach((Item item) {
      if(itemsByUnit.containsKey(item.uom)) {
        itemsByUnit[item.uom].add(item);
      } else {
        itemsByUnit[item.uom] = <Item>[item];
      }
    });

    return itemsByUnit;
  }

  static double meanItemPrices(List<Item> items) {
    double sum = 0;
    items.forEach((item) => sum += (item.priceParsed / item.sizeParsed));
    return (sum / items.length);
  }
}
