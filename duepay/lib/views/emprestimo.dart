import 'package:duepay/models/proposta.dart';
import 'package:duepay/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Emprestimo extends StatefulWidget {
  @override
  _EmprestimoState createState() => _EmprestimoState();
}

class _EmprestimoState extends State<Emprestimo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Empréstimo'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RaisedButton(
              child: Text('Novo'),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  Routes.EMP_TIMELINE,
                  arguments: 0,
                );
              },
            ),
            RaisedButton(
              child: Text('Teste'),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  Routes.EMP_TIMELINE,
                  arguments: 862,
                );
              },
            ),
            RaisedButton(
              child: Text('Consultar'),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.EMP_CONSULTA);
              },
            )
          ]),
    );
  }
}
