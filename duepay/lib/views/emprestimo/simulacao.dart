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
  UserEmprestimo user;
  String _parcelas;
  Widget tab;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  loadUser() async {
    try {
      logUser = Usuario.fromJson(await Storage.recupera("user"));
      final resp = jsonDecode(await EmprestimoDao.getSaldo(logUser));
      //print(resp['info']);
      String val = resp['limite']['SALDO'];

      setState(() {
        saldo = double.parse(val.replaceAll(',', '.'));
        maximo = resp['maximo']['results'];
        user = UserEmprestimo(resp['info']['CLIENTE'], resp['info']['CPF'],
            resp['info']['CARTAO']);
        user.token = logUser.token;
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
      body: SingleChildScrollView(
        child: Column(
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
                width: double.infinity,
                // margin: EdgeInsets.fromLTRB(50, 25, 50, 25),
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
                  child: tab,
                ),
              ),
            ]),
      ),
    );
  }

  void doSimulacao() async {
    try {
      final resp = jsonDecode(await EmprestimoDao.getParcelas(valor, user));
      _parcelas = '[';
      if (resp['success']) {
        var rets = resp['parcelas'];
        rets.where((text) => text != null).forEach((text) {
          _parcelas += text['numeroParcelas'].toString() + ',';
        });
        _parcelas = _parcelas.substring(0, _parcelas.length - 1) + ']';
      }
      //print(_parcelas);
      getTabela(_parcelas);
      setState(() {});
    } catch (Excepetion) {
      print('fodeu' + Excepetion.toString());
    }
    //chamar o maximo de parcelas e depois o calculo das mesmas
    setState(() {
      tabela = true;
    });
  }

  getTabela(String parcelas) async {
    var data = jsonEncode({
      'selecao': {'parcelas': parcelas, 'valor': valor, 'iof': true}
    });
    try {
      final resp = jsonDecode(await EmprestimoDao.getTabela(data, logUser));

      if (resp['success']) {
        var rets = jsonDecode(resp['dados']);
        setState(() {
          tabela = true;
          tab = criaTabela(rets);
        });
      }

      //  setState(() {});
    } catch (Excepetion) {
      print('fodeu' + Excepetion.toString());
    }
    //chamar o maximo de parcelas e depois o calculo das mesmas
  }

  criaTabela(List<dynamic> lista) {
    String line = 'PARCELAS,VALOR PARC,TOTAL';
    for (int i = 0; i < lista.length; i++) {
      final coisa = jsonDecode(lista[i]['dados']);

      line += ';' +
          coisa[0]['numero_parcelas'].toString() +
          ',' +
          coisa[0]['valor_parcela'].toString() +
          ',' +
          coisa[0]['total'].toString();
    }
    print('linha: $line');
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
        /* for (int i = 0; i < lista.length; i++){
              _criarLinhaTable(lista[i].toString());
            }*/
        _criarLinhaTable(line),
        /*  _criarLinhaTable("25, Palmeiras,16 "),
        _criarLinhaTable("20, Santos, 5"),
        _criarLinhaTable("17, Flamento, 6"),*/
      ],
    );
  }

  _criarLinhaTable(String listaNomes) {
    return TableRow(
      children: listaNomes.split(';').map((linha) {
        linha.split(',').map((name) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              name,
              style: TextStyle(fontSize: 12.0),
            ),
            padding: EdgeInsets.all(8.0),
          );
        });
      }).toList(),
    );
  }
}

class UserEmprestimo {
  final int cliente;
  final String cpf;
  final String cartao;
  String token;

  UserEmprestimo(this.cliente, this.cpf, this.cartao);
}
