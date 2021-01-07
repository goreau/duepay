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
    // const menu = {...DUMMY_MENU};
    const menu = {};
    return Scaffold(
      appBar: AppBar(
        title: Text('DuePay'),
      ),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox.fromSize(
                  size: Size(100, 100),
                  child: OutlineButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(Routes.EXTRATO);
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.blue,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.list),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 18.0, 0.0, 0.0),
                          child: Text(
                            "Extrato",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox.fromSize(
                  size: Size(100, 100),
                  child: OutlineButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(Routes.EMPRESTIMO);
                    },
                    color: Colors.blue,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.money),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 18.0, 0.0, 0.0),
                          child: Text(
                            "Empréstimo",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Text(widget.user.nome),
          ]),
      drawer: Container(
          width: 250,
          child: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              Container(
                height: 100.0,
                child: DrawerHeader(
                  child: ListTile(
                    /*leading: CircleAvatar(
                      child: //Image.asset('assets/images/logo.png'),
                          Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                                image: AssetImage('assets/images/logo.png'),
                                fit: BoxFit.cover),
                            borderRadius:
                                BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ]),
                      ),
                    ),*/
                    // title: Text('DuePay'),
                    subtitle: Text(
                      'Aqui seu salário vale sempre mais.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 230, 204, 100),
                      image: DecorationImage(
                          image: AssetImage("assets/images/logo.png"),
                          fit: BoxFit.fitWidth)),
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
