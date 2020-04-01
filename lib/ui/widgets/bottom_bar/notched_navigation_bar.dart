import 'package:crownapp/model/notifier/navigation_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationItem {
  final IconData icon;
  final String label;

  NavigationItem({this.icon, this.label});
}

class NotchedNavigationBar extends StatelessWidget {
  NotchedNavigationBar(
      {@required this.selectedIndex,
      this.insertMiddleItem: false,
      this.navigationItems,
      this.height: 60.0,
      this.iconSize: 24.0,
      this.backgroundColor,
      this.color,
      this.selectedColor,
      this.notchedShape});

  final bool insertMiddleItem;
  final double height;
  final double iconSize;
  final int selectedIndex;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final List<NavigationItem> navigationItems;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NavigationModel>(context, listen: false);
    List<Widget> items = List.generate(navigationItems.length, (int index) {
      return _buildTabItem(
          item: navigationItems[index],
          tabIndex: index,
          selectedIndex: provider.currentIndex,
          provider: provider);
    });
    if (this.insertMiddleItem) {
      items.insert(items.length >> 1, _buildMiddleTabItem());
    }

    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items,
      ),
      shape: CircularNotchedRectangle(),
      color: backgroundColor,
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: this.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: this.iconSize),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    int tabIndex,
    int selectedIndex,
    NavigationItem item,
    NavigationModel provider,
  }) {
    Color color = selectedIndex == tabIndex ? this.selectedColor : this.color;

    return Expanded(
      child: SizedBox(
        height: this.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => provider.currentIndex = tabIndex,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.icon, color: color, size: this.iconSize),
                Text(
                  item.label,
                  style: TextStyle(color: color),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
