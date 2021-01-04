import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  void initState() {
    //if ()
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DuePay'),
      ),
      body: new Container(),
      drawer: Container(
          width: 250,
          child: Drawer(
            child: ListView(children: <Widget>[
              Container(
                height: 100,
                child: DrawerHeader(
                  child: ListTile(
                    leading: Icon(Icons.bug_report),
                    title: Text('Sisamob'),
                    subtitle: Text('Sistema para coleta de informações'),
                  ),
                  decoration: BoxDecoration(color: Colors.greenAccent),
                ),
              ),
            ]),
          )),
    );
  }
}
