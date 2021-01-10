import 'package:duepay/util/routes.dart';
import 'package:flutter/material.dart';

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
      body: Column(children: [
        RaisedButton(
          child: Text('Novo'),
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.EMP_TIMELINE);
          },
        )
      ]),
    );
  }
}
