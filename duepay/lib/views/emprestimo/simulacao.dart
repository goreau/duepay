import 'dart:convert';

import 'package:duepay/comunicacao/emprestimo_dao.dart';
import 'package:duepay/models/usuario.dart';
import 'package:duepay/util/storage.dart';
import 'package:flutter/material.dart';

class Simulacao extends StatefulWidget {
  @override
  _SimulacaoState createState() => _SimulacaoState();
}

class _SimulacaoState extends State<Simulacao> {
  Usuario logUser;
  double saldo = 0.0;
  double maximo = 0.0;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  loadUser() async {
    try {
      Usuario user = Usuario.fromJson(await Storage.recupera("user"));
      final resp = jsonDecode(await EmprestimoDao.getSaldo(user));
      String val = resp['limite']['SALDO'];

      setState(() {
        saldo = double.parse(val.replaceAll(',', '.'));
        maximo = resp['maximo']['results'];
      });
    } catch (Excepetion) {
      print('fodeu' + Excepetion.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simulação'),
      ),
      body: Column(children: [
        Text('Seu saldo é $saldo'),
        Text('Seu Limite é $maximo'),
      ]),
    );
  }
}
