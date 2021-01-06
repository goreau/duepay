import 'package:flutter/material.dart';

class Emprestimo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Empréstimo'),
      ),
      body: Column(
        children: [
          Text('Tela de extrato'),
          RaisedButton(
            onPressed: () => Navigator.of(context).pop(),
            // color: Colors.green,
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
            child: Text('Voltar'),
          ),
        ],
      ),
    );
  }
}
