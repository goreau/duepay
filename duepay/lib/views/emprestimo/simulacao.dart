import 'dart:convert';

import 'package:duepay/comunicacao/emprestimo_dao.dart';
import 'package:duepay/models/usuario.dart';
import 'package:duepay/util/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class Simulacao extends StatefulWidget {
  @override
  _SimulacaoState createState() => _SimulacaoState();
}

class _SimulacaoState extends State<Simulacao> {
  Usuario logUser;
  double saldo = 0.0;
  double maximo = 0.0;
  //double valor = 0.0;
  String senha = '';

  int parcelas = 5;
  bool visible = true;
  bool tabela = false;
  UserEmprestimo user;
  String _parcelas;
  Widget tab;

  final _form = GlobalKey<FormState>();
  final _senhaController = TextEditingController();

  final currency = MoneyMaskedTextController(
      decimalSeparator: '.',
      thousandSeparator: ',',
      leftSymbol: 'R\$ ',
      initialValue: 0.0);

  final vlParcelas = MoneyMaskedTextController(
      decimalSeparator: '.',
      thousandSeparator: ',',
      leftSymbol: 'R\$ ',
      initialValue: 0.0);

  final vlTotal = MoneyMaskedTextController(
      decimalSeparator: '.',
      thousandSeparator: ',',
      leftSymbol: 'R\$ ',
      initialValue: 0.0);

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
      print('fodeu bem' + Excepetion.toString());
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
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                child: TextField(
                  controller: currency,
                  /* onChanged: (v) {
                    this.valor = currency.numberValue;
                  },*/
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
                    child: tabela
                        ? Column(
                            children: [
                              Text('Parcelas'),
                              tab,
                            ],
                          )
                        : null,
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  void doSimulacao() async {
    try {
      final resp = jsonDecode(
          await EmprestimoDao.getParcelas(currency.numberValue, user));
      _parcelas = '[';
      if (resp['success']) {
        var rets = resp['parcelas'];
        rets.where((text) => text != null).forEach((text) {
          _parcelas += text['numeroParcelas'].toString() + ',';
        });
        _parcelas = _parcelas.substring(0, _parcelas.length - 1) + ']';
      }
      //print(_parcelas);
      await getTabela(_parcelas);
      setState(() {
        tabela = true;
      });
    } catch (Excepetion) {
      print('fodeu mais' + Excepetion.toString());
    }
  }

  getTabela(String parcelas) async {
    var data = jsonEncode({
      'selecao': {
        'parcelas': parcelas,
        'valor': currency.numberValue,
        'iof': true
      }
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
      print('fodeu com tudo' + Excepetion.toString());
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
      Tabela t = Tabela.fromJson(coisa[0]);
      print(t);
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
      print(p);
      /* Tabela t =
          Tabela(int.parse(p[0]), double.parse(p[1]), double.parse(p[2]));*/

      // linhas.add(t);
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
                    Text(item.valor_parcela.toString()),
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
                    seleciona(item);
                  }),
                ],
              ),
            ))
        .toList();
    return rows;
  }

  seleciona(Tabela opt) {
    vlParcelas.updateValue(opt.valor_parcela);
    vlTotal.updateValue(opt.total);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sua Opção',
            style:
                TextStyle(fontSize: 14, color: Theme.of(context).accentColor),
          ),
          content: Stack(
            children: <Widget>[
              Column(
                children: [
                  Text(
                    'Confirma a solicitação dos valores abaixo?',
                    style: TextStyle(
                        fontSize: 13, color: Theme.of(context).accentColor),
                  ),
                  Column(
                    children: [
                      Container(
                        height: 60,
                        child: Card(
                          elevation: 10,
                          shadowColor: Color.fromRGBO(57, 72, 87, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Valor Solicitado: ',
                                  style: TextStyle(
                                    color: Color.fromRGBO(57, 72, 87, 1),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  currency.text,
                                  style: TextStyle(
                                    color: Colors.green[900],
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        child: Card(
                          elevation: 10,
                          shadowColor: Color.fromRGBO(57, 72, 87, 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Número de Parcelas:',
                                style: TextStyle(
                                  color: Color.fromRGBO(57, 72, 87, 1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                opt.numero_parcelas.toString(),
                                style: TextStyle(
                                  color: Colors.green[900],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        child: Card(
                          elevation: 10,
                          shadowColor: Color.fromRGBO(57, 72, 87, 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Valor das parcelas:',
                                style: TextStyle(
                                  color: Color.fromRGBO(57, 72, 87, 1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                vlParcelas.text,
                                style: TextStyle(
                                  color: Colors.green[900],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        child: Card(
                          elevation: 10,
                          shadowColor: Color.fromRGBO(57, 72, 87, 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Total a Pagar:',
                                style: TextStyle(
                                  color: Color.fromRGBO(57, 72, 87, 1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                vlTotal.text,
                                style: TextStyle(
                                  color: Colors.green[900],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          actions: [
            FlatButton(
              child: Text('Não. Simular nova proposta.'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Confirmo a Opção'),
              onPressed: () {
                Navigator.of(context).pop();
                autoriza();
              },
            ),
          ],
        );
      },
    );
  }

  autoriza() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Senha do Cartão',
            style:
                TextStyle(fontSize: 13, color: Theme.of(context).accentColor),
          ),
          content: Stack(
            children: <Widget>[
              Column(children: [
                Text(
                  'Informe a sua senha pessoal de compra. Os valores solicitados serão posteriormente debitados do seu cartão.',
                  style: TextStyle(
                      fontSize: 13, color: Theme.of(context).accentColor),
                ),
                Form(
                  key: _form,
                  child: Column(
                    children: [
                      TextFormField(
                        obscureText: true,
                        style: new TextStyle(
                          fontSize: 12,
                        ),
                        controller: _senhaController,
                        decoration:
                            InputDecoration(labelText: 'Senha do cartão'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'A senha é obrigatória!!';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          setState(() {
                            senha = value;
                            print(senha);
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              empenho(0);
                            },
                            color: Color.fromRGBO(57, 72, 87, 1),
                            textColor: Colors.white,
                            padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                            child: Text('Cancelar'),
                          ),
                          RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              empenho(1);
                            },
                            color: Color.fromRGBO(57, 72, 87, 1),
                            textColor: Colors.white,
                            padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                            child: Text('Entrar'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ]),
            ],
          ),
        );
      },
    );
  }

  empenho(int opcao) {
    if (opcao == 0) {
      print('Cara cancelou');
    } else {
      if (_form.currentState.validate()) {
        _form.currentState.save();
      }
      print(senha);
    }
  }
}

class Tabela {
  int numero_parcelas;
  double valor_parcela;
  double valor_requerido;
  double valor_financiado;
  double total;
  double juros;
  String data_emprestimo;
  String primeiro_vencimento;
  String ultimo_vencimento;
  double aliquota_iof_dia;
  double aliquota_iof_adicional;
  double tot_iof;
  double tot_dcp;
  double valor_tac;
  double cet_a;
  double cet_m;
  List<Titulo> titulos;

  Tabela(
    this.numero_parcelas,
    this.valor_parcela,
    this.valor_requerido,
    this.valor_financiado,
    this.total,
    this.juros,
    this.data_emprestimo,
    this.primeiro_vencimento,
    this.ultimo_vencimento,
    this.aliquota_iof_dia,
    this.aliquota_iof_adicional,
    this.tot_iof,
    this.tot_dcp,
    this.valor_tac,
    this.cet_a,
    this.cet_m,
    this.titulos,
  );

  factory Tabela.fromJson(dynamic json) {
    if (json['titulos'] != null) {
      var tagObjsJson = json['titulos'] as List;
      List<Titulo> _tags =
          tagObjsJson.map((tagJson) => Titulo.fromJson(tagJson)).toList();
      return Tabela(
        json['numero_parcelas'] as int,
        json['valor_parcela'] as double,
        double.parse(json['valor_requerido'].toString()),
        json['valor_financiado'] as double,
        json['total'] as double,
        json['juros'] as double,
        json['data_emprestimo'],
        json['primeiro_vencimento'],
        json['ultimo_vencimento'],
        json['aliquota_iof_dia'] as double,
        json['aliquota_iof_adicional'] as double,
        json['tot_iof'] as double,
        json['tot_dcp'] as double,
        double.parse(json['valor_tac'].toString()),
        json['cet_a'] as double,
        json['cet_m'] as double,
        _tags,
      );
    } else {
      return Tabela(
        json['numero_parcelas'] as int,
        json['valor_parcela'] as double,
        json['valor_requerido'] as double,
        json['valor_financiado'] as double,
        json['total'] as double,
        json['juros'] as double,
        json['data_emprestimo'],
        json['primeiro_vencimento'],
        json['ultimo_vencimento'],
        json['aliquota_iof_dia'] as double,
        json['aliquota_iof_adicional'] as double,
        json['tot_iof'] as double,
        json['tot_dcp'] as double,
        json['valor_tac'] as double,
        json['cet_a'] as double,
        json['cet_m'] as double,
        null,
      );
    }
  }
}

class Titulo {
  double saldo_devedor;
  double juros;
  double valor_prestacao;
  double amortizacao;
  int numero_titulo;
  String vencimento;
  int dias_corridos;
  double taxa_iof;
  double valor_iof;

  Titulo(
    this.saldo_devedor,
    this.juros,
    this.valor_prestacao,
    this.amortizacao,
    this.numero_titulo,
    this.vencimento,
    this.dias_corridos,
    this.taxa_iof,
    this.valor_iof,
  );

  factory Titulo.fromJson(dynamic json) {
    return Titulo(
      json['saldo_devedor'] as double,
      json['juros'] as double,
      json['valor_prestacao'] as double,
      json['amortizacao'] as double,
      json['numero_titulo'] as int,
      json['vencimento'],
      json['dias_corridos'] as int,
      json['taxa_iof'] as double,
      json['valor_iof'] as double,
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
