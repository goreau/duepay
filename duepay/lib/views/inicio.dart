import 'package:duepay/components/menu_tile.dart';
import 'package:duepay/data/dummy_menu.dart';
import 'package:duepay/models/usuario.dart';
import 'package:duepay/util/routes.dart';
import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  final Usuario user;
  Inicio({Key key, @required this.user}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    const menu = {...DUMY_MENU};

    return Scaffold(
      appBar: AppBar(
        title: Text('DuePay'),
      ),
      body: new Column(children: <Widget>[
        RaisedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.EXTRATO);
          },
          color: Colors.green,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
          child: Text('Extrato'),
        ),
        Text(widget.user.nome),
      ]),
      drawer: Container(
          width: 250,
          child: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              Container(
                height: 85.0,
                child: DrawerHeader(
                  child: Text(
                    'Duepay',
                    style: new TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                ),
              ),
              Container(
                height: double.maxFinite,
                child: ListView.builder(
                  itemCount: menu.length,
                  itemBuilder: (ctx, i) => MenuTile(menu.values.elementAt(i)),
                ),
              ),
            ]),
          )),
    );
  }
}
