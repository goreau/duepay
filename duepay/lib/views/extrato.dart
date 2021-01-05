import 'package:flutter/material.dart';

class Extrato extends StatefulWidget {
  @override
  _ExtratoState createState() => _ExtratoState();
}

class _ExtratoState extends State<Extrato> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Extratos'),
        ),
        body: Column(
          children: [
            Text('Tela de extrato'),
            RaisedButton(
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.green,
              textColor: Colors.white,
              padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
              child: Text('Voltar'),
            ),
          ],
        ));
  }
}
