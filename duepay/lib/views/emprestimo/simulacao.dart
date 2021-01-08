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
  double valor = 0.0;
  int parcelas = 5;
  bool visible = true;
  bool tabela = false;

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
    visible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simulação'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Visibility(
                  visible: visible,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: CircularProgressIndicator(),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Saldo de sua conta:'),
                    Text('Limite para empréstimo:'),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$saldo',
                      style: TextStyle(
                        color: Colors.green[800],
                      ),
                    ),
                    Text(
                      '$maximo',
                      style: TextStyle(
                        color: Colors.green[800],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(50, 25, 50, 25),
              child: TextField(
                decoration: InputDecoration(hintText: 'Valor do Empréstimo'),
                onChanged: (valor) {
                  this.valor = double.parse(valor);
                },
              ),
            ),
            RaisedButton(
              onPressed: doSimulacao,
              color: Color.fromRGBO(57, 72, 87, 1),
              textColor: Colors.white,
              padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
              child: Text('Simular'),
            ),
            Visibility(
              visible: tabela,
              child: Container(
                margin: EdgeInsets.only(bottom: 30),
                child: criaTabela(),
              ),
            ),
          ]),
    );
  }

  void doSimulacao() {
    //chamar o maximo de parcelas e depois o calculo das mesmas
    setState(() {
      tabela = true;
    });
  }

  criaTabela() {
    return Table(
      defaultColumnWidth: FixedColumnWidth(150.0),
      border: TableBorder(
        horizontalInside: BorderSide(
          color: Colors.black,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        verticalInside: BorderSide(
          color: Colors.black,
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),
      children: [
        _criarLinhaTable("Pontos, Time, Gols"),
        _criarLinhaTable("25, Palmeiras,16 "),
        _criarLinhaTable("20, Santos, 5"),
        _criarLinhaTable("17, Flamento, 6"),
      ],
    );
  }

  _criarLinhaTable(String listaNomes) {
    return TableRow(
      children: listaNomes.split(',').map((name) {
        return Container(
          alignment: Alignment.center,
          child: Text(
            name,
            style: TextStyle(fontSize: 12.0),
          ),
          padding: EdgeInsets.all(8.0),
        );
      }).toList(),
    );
  }
}
