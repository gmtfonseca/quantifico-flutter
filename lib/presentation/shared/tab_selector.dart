import 'package:flutter/material.dart' hide Tab;
import 'package:quantifico/data/model/tab.dart';

class TabSelector extends StatelessWidget {
  final Tab activeTab;
  final Function(Tab) onTabSelected;

  TabSelector({
    Key key,
    @required this.activeTab,
    @required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: Tab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(Tab.values[index]),
      items: _buildItems(),
    );
  }

  List<BottomNavigationBarItem> _buildItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.assessment),
        title: Text('Insights'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.assignment),
        title: Text('Notas Fiscais'),
      ),
    ];
  }
}
