import 'package:flutter/material.dart';
import 'package:grocery_helper/ui/pages/home.dart';
import 'package:grocery_helper/ui/pages/items/list_item.dart';

class DrawerWidget extends StatelessWidget {
  final int selectedIndex;
  final List<_NavDestination> links = <_NavDestination>[
    _NavDestination(
      icon: Icons.home,
      text: 'Home',
      destinationBuilder: (context) => HomePage(),
    ),
    _NavDestination(
      icon: Icons.list,
      text: 'Items',
      destinationBuilder: (context) => ItemsPage(),
    )
  ];

  DrawerWidget({
    Key key,
    @required this.selectedIndex,
  }) : super(key: key);

  List<Widget> getNavList(BuildContext context) {
//    return links.map((e) => e.toWidget(context)).toList(); // this doesnt work since map doesn't give us the index
    List<Widget> result = [];

    result.add(DrawerHeader(
      child: Text("Grocery Helper"),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
    ));

    for (int i = 0; i < links.length; ++i) {
      result
          .add(links[i].toWidget(context, isSelected: i == this.selectedIndex));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    ListView listView = new ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: getNavList(context),
    );

    return new Drawer(
      child: listView,
    );
  }
}

class _NavDestination {
  final IconData icon;
  final String text;
  final Function(BuildContext context) destinationBuilder;

  _NavDestination({
    @required this.icon,
    @required this.text,
    @required this.destinationBuilder,
  });

  Widget toWidget(BuildContext context, {isSelected = false}) {
    return ListTile(
      leading: new Icon(this.icon),
      title: new Text(this.text),
      selected: isSelected,
      onTap: () {
        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
              builder: this.destinationBuilder,
            ));
      },
    );
  }
}
