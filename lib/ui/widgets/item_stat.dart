import 'package:flutter/material.dart';

class ItemStat extends StatelessWidget {
  final String categoryName;
  final int itemCount;

  final double averagePricePer;
  final String uom;

  final Function onTap;

  const ItemStat({
    Key key,
    @required this.categoryName,
    @required this.itemCount,
    @required this.averagePricePer,
    @required this.uom,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(this.categoryName),
      subtitle: Text('by ${itemCount} purchase(s)'),
      trailing: Text('\$${averagePricePer.toStringAsFixed(3)} / ${uom}'),
      onTap: onTap ?? () {},
    );
  }
}
