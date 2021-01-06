import 'package:duepay/models/menu.dart';
import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final Menu menu;

  const MenuTile(this.menu);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: menu.icon,
      title: Text(menu.title),
      subtitle: Text(menu.subtitle),
      onTap: menu.tap,
    );
  }
}
