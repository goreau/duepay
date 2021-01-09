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
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text('Parcelas'),
                        tab,
                      ],
                    ),
                  ),
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
    String line = '';
    for (int i = 0; i < lista.length; i++) {
      final coisa = jsonDecode(lista[i]['dados']);

      line += coisa[0]['numero_parcelas'].toString() +
          ',' +
          coisa[0]['valor_parcela'].toString() +
          ',' +
          coisa[0]['total'].toString() +
          ';';
    }
    line = line.substring(0, line.length - 1);

    return DataTable(
      columns: [
        DataColumn(
          label: Text('No'),
        ),
        DataColumn(
          label: Text('VALOR'),
        ),
        DataColumn(
          label: Text('TOTAL'),
        ),
        DataColumn(
          label: Text('SELEC.'),
        ),
      ],
      rows: _criarLinhaTable(line),
    );
  }

  _criarLinhaTable(String listaNomes) {
    int val = 0;
    int cont = 0;
    List<DataRow> rows = [];
    List<Tabela> linhas = [];
    listaNomes.split(';').map((linha) {
      List<String> p = linha.split(',');
      Tabela t =
          Tabela(int.parse(p[0]), double.parse(p[1]), double.parse(p[2]));
      linhas.add(t);
    }).toList();
    linhas
        .map((item) => rows.add(
              DataRow(
                cells: [
                  DataCell(
                    Text(item.numero_parcelas.toString()),
                    showEditIcon: false,
                    placeholder: false,
                  ),
                  DataCell(
                    Text(item.valor_parcelas.toString()),
                    showEditIcon: false,
                    placeholder: false,
                  ),
                  DataCell(
                    Text(item.total.toString()),
                    showEditIcon: false,
                    placeholder: false,
                  ),
                  DataCell(
                      Icon(
                        Icons.thumb_up_alt,
                        color: Color.fromRGBO(214, 168, 76, 1),
                      ),
                      showEditIcon: false,
                      placeholder: false, onTap: () {
                    seleciona(item.numero_parcelas);
                  }),
                ],
              ),
            ))
        .toList();
    return rows;
  }

/*
  _criarLinhaTable(String listaNomes) {
    int val = 0;
    int cont = 0;
    List<DataRow> rows = [];
    listaNomes.split(';').map((linha) {
      List<DataCell> cell = [];
      linha.split(',').map((name) {
        val = cont++ == 0 ? int.parse(name) : val;
        cell.add(
          DataCell(
            Text(name),
            showEditIcon: false,
            placeholder: false,
          ),
        );
      }).toList();
      cell.add(
        DataCell(
            IconButton(
              icon: new Icon(
                Icons.thumb_up_alt,
                color: Color.fromRGBO(214, 168, 76, 1),
              ),
              onPressed: () {
                seleciona(1);
              },
            ), onTap: () {
          print(val);
        }),
      );
      rows.add(DataRow(
        cells: cell,
        onSelectChanged: (bool selected) {
          if (selected) {
            var xx = cell[0].child;
            print('row-selected: $xx');
          }
        },
      ));
      cont = 0;
    }).toList();

    return rows;
  }*/

/*
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
    return Table(
      border: TableBorder.all(),
      children: _criarLinhaTable(line),
    );
  }

  _criarLinhaTable(String listaNomes) {
    List<TableRow> rows = [];
    int count = 0;
    int pula = 0;
    int parc = 0;
    listaNomes.split(';').map((linha) {
      List<Widget> cell = [];
      linha.split(',').map((name) {
        if (pula > 0) {
          parc = count++ == 0 ? int.parse(name) : parc;
        }
        cell.add(
          Center(
            child: Text(
              name,
              style: TextStyle(fontSize: 12.0),
            ),
          ),
        );
      }).toList();
      if (pula++ == 0) {
        cell.add(Text('SELECIONAR'));
      } else {
        cell.add(IconButton(
            icon: new Icon(
              Icons.thumb_up_alt,
              color: Color.fromRGBO(214, 168, 76, 1),
            ),
            onPressed: () {
              seleciona(parc);
            }));
      }
      count = 0;
      rows.add(TableRow(
        children: cell,
      ));
    }).toList();

    return rows;
  }
*/
  seleciona(int opt) {
    print(opt);
  }
}

class Tabela {
  int numero_parcelas;
  double valor_parcelas;
  double total;

  Tabela(this.numero_parcelas, this.valor_parcelas, this.total);
}

class UserEmprestimo {
  final int cliente;
  final String cpf;
  final String cartao;
  String token;

  UserEmprestimo(this.cliente, this.cpf, this.cartao);
}
