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
            child: ListView(children: <Widget>[
              Container(
                height: 100,
                child: DrawerHeader(
                  child: ListTile(
                    leading: Icon(Icons.bug_report),
                    title: Text('DuePay'),
                    subtitle: Text('Blá blá blá'),
                  ),
                  decoration: BoxDecoration(color: Colors.greenAccent),
                ),
              ),
            ]),
          )),
    );
  }
}
