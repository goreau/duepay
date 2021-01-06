import 'package:flutter/cupertino.dart';

class Menu {
  final String title;
  final String subtitle;
  final Icon icon;
  final Function tap;

  const Menu({@required this.title, this.subtitle, this.icon, this.tap});
}
