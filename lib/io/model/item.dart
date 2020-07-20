import '../model.dart';

class Item extends Model {
  String genericItemName;
  String itemName;
  String price;
  String size;

  Item.empty() : super(id: null);

  Item({
    id,
    extra,
    this.genericItemName,
    this.itemName,
    this.price,
    this.size
  }) : super(id: id, extra: extra);

  Item.fromJson(Map<String, dynamic> json)
      : genericItemName = json['genericItemName'],
        itemName = json['itemName'],
        price = json['price'],
        size = json['size'],
        super.fromJson(json);

  String get categoryKey {
    return genericItemName.toUpperCase();
  }

  String get uom {
    return size.replaceAll(new RegExp(r'[-0-9.,]+'), '');
  }

  //TODO improve this
  double get priceParsed {
    return double.parse(price.replaceAll(RegExp(r"[A-Za-z\$]+"), ''));
  }

  //TODO improve this
  double get sizeParsed {
    return double.parse(size.replaceAll(RegExp(r"[A-Za-z]+"), ''));
  }

  @override
  Map<String, dynamic> moreToJson() => {
    'genericItemName': this.genericItemName,
    'itemName': this.itemName,
    'price': this.price,
    'size': this.size
  };

}