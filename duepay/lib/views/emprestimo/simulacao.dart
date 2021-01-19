import 'dart:convert';
import 'package:duepay/comunicacao/comunica.dart';
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

  Tabela currentOption;

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
    if (currency.numberValue > maximo) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
                'Você não pode solicitar um valor maior que seu limite para empréstimo, de  R\$ $maximo'),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      currency.updateValue(0.0);
    } else {
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
    List<Tabela> linhas = [];
    for (int i = 0; i < lista.length; i++) {
      final coisa = jsonDecode(lista[i]['dados']);

      /* line += coisa[0]['numero_parcelas'].toString() +
          ',' +
          coisa[0]['valor_parcela'].toString() +
          ',' +
          coisa[0]['total'].toString() +
          ';';*/
      Tabela t = Tabela.fromJson(coisa[0]);
      linhas.add(t);
    }
    // line = line.substring(0, line.length - 1);

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
      rows: _criarLinhaTable(linhas),
    );
  }

  _criarLinhaTable(List<Tabela> linhas) {
    int val = 0;
    int cont = 0;
    List<DataRow> rows = [];

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

//Usuario escolheu uma proposta -  se confrmar a opção vai salvar no banco
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
              onPressed: () async {
                Navigator.of(context).pop();
                currentOption = opt;
                int idBanco = await empenho();
                if (idBanco == 0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: new Text(
                            'Houve um erro gravando as informações na base de dados.'),
                        actions: <Widget>[
                          FlatButton(
                            child: new Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  autoriza(idBanco);
                }
              },
            ),
          ],
        );
      },
    );
  }

  //pega a senha de compras do usuario e reserva os valores na Telenet
  autoriza(int idBanco) {
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
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              //chamar o cancela, apagando do banco
                            },
                            color: Color.fromRGBO(57, 72, 87, 1),
                            textColor: Colors.white,
                            padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                            child: Text('Cancelar'),
                          ),
                          RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              reservaTelenet(idBanco);
                            },
                            color: Color.fromRGBO(57, 72, 87, 1),
                            textColor: Colors.white,
                            padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                            child: Text('Prosseguir'),
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

  //grava na base nossa os dados da ´roposta selecionada
  Future<int> empenho() async {
    int idBanco = 0;
    // visible = true;
    var data = jsonEncode({
      'post': {
        'opcao': {
          'dt_solicita': currentOption.data_emprestimo,
          'proposta': currentOption.toJson(),
          'status': 0,
          'cartao': user.cartao,
        }
      }
    });
    try {
      final resp = jsonDecode(await EmprestimoDao.putBanco(data, logUser));

      if (resp['success']) {
        var ret = jsonDecode(resp['numero_ccb']);

        setState(() {
          idBanco = ret;
        });
      }

      //  setState(() {});
    } catch (Excepetion) {
      print('fodeu com tudo' + Excepetion.toString());
      // return false;
    }
    return idBanco;
  }

  Future<bool> reservaTelenet(int ret) async {
    if (_form.currentState.validate()) {
      _form.currentState.save();
    }

    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    var data = jsonEncode({
      'post': {
        'dados': {
          'numeroCartao': user.cartao, // user.cartao,
          'tipoCartao': 0, // padrão para pós pago
          'senhaCartao': senha,
          'nsuHost': ret.toString().padLeft(6, '0'),
          'dataHoraTransacao': date.toString(),
          'valor': currentOption.valor_financiado,
          'numeroParcelas': currentOption.numero_parcelas,
        }
      }
    });
    try {
      final resp =
          jsonDecode(await EmprestimoDao.empenhoTelenet(data, logUser));
      // Map<String, dynamic> resp;
      // resp['success'] = false;
      // resp['message'] = 'SENHA ERRADA';
      if (resp['success']) {
        Map<String, dynamic> user = await currentOption.getUser(logUser);
        String dados = jsonEncode(currentOption.toCCB(ret, user));
        updateProposta(ret, dados, 1);
        return true;
      } else {
        String msg = resp['message'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(msg),
              actions: <Widget>[
                FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        removeProposta(ret);
        return false;
      }

      //  setState(() {});
    } catch (Excepetion) {
      print('fodeu com tudo' + Excepetion.toString());
      return false;
    }
  }

  Future<bool> importaOperacao(int ret) async {
    try {
      Map<String, dynamic> user = await currentOption.getUser(logUser);
      String dados = jsonEncode(currentOption.toCCB(ret, user));
      var data = jsonEncode({
        'ccb': dados,
      });
      final resp =
          jsonDecode(await EmprestimoDao.importaOperacao(data, logUser));

      if (resp['status_retorno'] != 'Erro') {
        int id = ret;
        String ccb = resp['retorno'][0]['cliente']['operacao'];
        int status = resp['retorno'][0]['cliente']['cod_status'];
        updateProposta(id, ccb, status);
      } else {
        print('não foi possível reservar os valores na telenet');
        return false;
      }

      //  setState(() {});
    } catch (Excepetion) {
      print('fodeu com tudo' + Excepetion.toString());
      return false;
    }
  }

  bool updateProposta(int id, String ccb, int status) {
    try {
      var data = jsonEncode({
        'id': {
          'id': id,
          'ccb': ccb,
          'status': status,
        }
      });

      EmprestimoDao.updateProposta(data, logUser);
      return true;
    } catch (e) {
      print('fodeu com tudo' + e.toString());
      return false;
    }
  }

  removeProposta(int id) {
    try {
      var data = jsonEncode({
        'post': {
          'id': id,
        }
      });

      EmprestimoDao.removeProposta(data, logUser);
      print('removeu');
      return true;
    } catch (e) {
      print('fodeu com tudo' + e.toString());
      return false;
    }
  }
}

class Vencimento {
  String data_vencimento;
  double saldo_devedor;
  int prazo_dias;
  double valor_parcela;
  double valor_principal;
  double valor_juros;
  int numero_documento;
  double valor_iof_parcela;
  double valor_tarifa_parcela;
  double capital_amortizado;

  Vencimento(
    this.data_vencimento,
    this.saldo_devedor,
    this.prazo_dias,
    this.valor_parcela,
    this.valor_principal,
    this.valor_juros,
    this.numero_documento,
    this.valor_iof_parcela,
    this.valor_tarifa_parcela,
    this.capital_amortizado,
  );
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
  String user;

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

  Future<Map<String, dynamic>> getUser(Usuario loguser) async {
    var teste = jsonDecode(await Comunica.getUsuario(loguser));
    return teste['dados'];
    //print(retUser);
  }

  factory Tabela.fromJson(dynamic json) {
    if (json['titulos'] != null) {
      var tagObjsJson = json['titulos'] as List;
      List<Titulo> _tags =
          tagObjsJson.map((tagJson) => Titulo.fromJson(tagJson)).toList();
      return Tabela(
        int.parse(json['numero_parcelas'].toString()),
        double.parse(json['valor_parcela'].toString()),
        double.parse(json['valor_requerido'].toString()),
        double.parse(json['valor_financiado'].toString()),
        double.parse(json['total'].toString()),
        double.parse(json['juros'].toString()),
        json['data_emprestimo'],
        json['primeiro_vencimento'],
        json['ultimo_vencimento'],
        double.parse(json['aliquota_iof_dia'].toString()),
        double.parse(json['aliquota_iof_adicional'].toString()),
        double.parse(json['tot_iof'].toString()),
        double.parse(json['tot_dcp'].toString()),
        double.parse(json['valor_tac'].toString()),
        double.parse(json['cet_a'].toString()),
        double.parse(json['cet_m'].toString()),
        _tags,
      );
    } else {
      return Tabela(
        int.parse(json['numero_parcelas'].toString()),
        double.parse(json['valor_parcela'].toString()),
        double.parse(json['valor_requerido'].toString()),
        double.parse(json['valor_financiado'].toString()),
        double.parse(json['total'].toString()),
        double.parse(json['juros'].toString()),
        json['data_emprestimo'],
        json['primeiro_vencimento'],
        json['ultimo_vencimento'],
        double.parse(json['aliquota_iof_dia'].toString()),
        double.parse(json['aliquota_iof_adicional'].toString()),
        double.parse(json['tot_iof'].toString()),
        double.parse(json['tot_dcp'].toString()),
        double.parse(json['valor_tac'].toString()),
        double.parse(json['cet_a'].toString()),
        double.parse(json['cet_m'].toString()),
        null,
      );
    }
  }

  Map<String, dynamic> toJson() => {
        'numero_parcelas': numero_parcelas,
        'valor_parcela': valor_parcela,
        'valor_requerido': valor_requerido,
        'valor_financiado': valor_financiado,
        'total': total,
        'juros': juros,
        'data_emprestimo': data_emprestimo,
        'primeiro_vencimento': primeiro_vencimento,
        'ultimo_vencimento': ultimo_vencimento,
        'aliquota_iof_dia': aliquota_iof_dia,
        'aliquota_iof_adicional': aliquota_iof_adicional,
        'tot_iof': tot_iof,
        'tot_dcp': tot_dcp,
        'valor_tac': valor_tac,
        'cet_a': cet_a,
        'cet_m': cet_m,
        'titulos': titulos,
      };

  Map<String, dynamic> toCCB(int ccb, Map<String, dynamic> user) => {
        'numero_ccb': ccb,
        'data_aceite': data_emprestimo,
        'data_liberacao': data_emprestimo,
        'valor_total': valor_financiado,
        'valor_iof': aliquota_iof_dia,
        'produto': 10,
        'taxa': juros * 100,
        'modalidade': 'EM',
        'periodicidade': 'M',
        'perc_iof': 1,
        'data_primeiro_vencimento': primeiro_vencimento,
        'valor_parcela': valor_parcela,
        'valor_tarifas': '0', // Definido que não terá custo para o contratante
        'tarifa_titulo': '0',
        'tac': valor_tac,
        'id_cliente': '',
        'rg': user['rg'],
        'cpfcnpj_cliente': user['cpf'],
        'nome_cliente': user['nome'],
        'razao_social': user['nome'],
        'email_cliente': user['email'],
        'nascimento': user['nascimento'],
        'endereco_cliente': user['endereco'],
        'numendereco': user['numero'],
        'bairro_cliente': user['bairro'],
        'cidade_cliente': user['cidade'],
        'estado_cliente': user['estado'],
        'cep_cliente': user['cep'],
        'telefone_cliente': user['telefone'],
        'orgaorg': user['rg_orgao'],
        'uf_orgaorg': user['rg_uf'],
        'nacionalidade': user['nacionalidade'],
        'receita_mes_01': '',
        'receita_mes_02': '',
        'receita_mes_03': '',
        'receita_mes_04': '',
        'receita_mes_05': '',
        'receita_mes_06': '',
        'receita_mes_07': '',
        'receita_mes_08': '',
        'receita_mes_09': '',
        'receita_mes_10': '',
        'receita_mes_11': '',
        'receita_mes_12': '',
        'tipo_documento': '',
        'escolaridade': 'OK',
        'estado_civil': 'OK',
        'tiporesidencia': 'OK',
        'inscestadual': '',
        'complemento': '',
        'sexo': '',
        'dtexprg': '',
        'naturalidade': '',
        'cpfconj': '',
        'nomeconjuge': '',
        'dtnascconjuge': '',
        'mae': user['mae'],
        'pai': '',
        'numdependentes': '',
        'fonecel': '',
        'temporesidencia': '',
        'vlaluguel': '',
        'tipo_endereco': '',
        'avalistas': [
          {'nome_avalista': '', 'cpf_avalista': '', 'grau_parentesco': ''}
        ],
        'socios': [
          {'cpf_socio': '', 'nome_socio': ''}
        ],
        'conta_bancaria': {
          'cod_banco': '082', // this.user.cod_banco,
          'conta': user['conta'],
          'contad': user['conta_dv'],
          'agencia': '0001', // this.user.agencia,
          'agenciad': '0', // this.user.agencia_dv,
          'operacao': '',
          'conjunta': '',
          'tipo': '',
          'cpf_favorecido': user['cpf'],
        },
        'vencimentos': titulos,
        /* 'prazo': numero_parcelas,

        'valor_requerido': valor_requerido,

        'total': total,

        'ultimo_vencimento': ultimo_vencimento,
        'aliquota_iof_dia': aliquota_iof_dia,
        'perc_iof_adicional': aliquota_iof_adicional,
        'tot_iof': tot_iof,
        'tot_dcp': tot_dcp,

        'cet_a': cet_a,
        'cet_m': cet_m,
        'titulos': titulos,*/
      };
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
      double.parse(json['saldo_devedor'].toString()),
      double.parse(json['juros'].toString()),
      double.parse(json['valor_prestacao'].toString()),
      double.parse(json['amortizacao'].toString()),
      int.parse(json['numero_titulo'].toString()),
      json['vencimento'],
      int.parse(json['dias_corridos'].toString()),
      double.parse(json['taxa_iof'].toString()),
      double.parse(json['valor_iof'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        'saldo_devedor': saldo_devedor,
        'juros': juros,
        'valor_prestacao': valor_prestacao,
        'amortizacao': amortizacao,
        'numero_titulo': numero_titulo,
        'vencimento': vencimento,
        'dias_corridos': dias_corridos,
        'taxa_iof': taxa_iof,
        'valor_iof': valor_iof,
      };

  Map<String, dynamic> toCCB(double principal) => {
        'saldo_devedor': saldo_devedor,
        'valor_juros': juros,
        'valor_parcela': valor_prestacao,
        'capital_amortizado': amortizacao,
        'numero_documento': numero_titulo.toString().padLeft(2, '0'),
        'data_vencimento': vencimento,
        'prazo_dias': dias_corridos,
        'taxa_iof': taxa_iof,
        'valor_iof_parcela': valor_iof,
        'valor_tarifa_parcela': 0,
        'valor_principal': principal,
      };
}

class UserEmprestimo {
  final int cliente;
  final String cpf;
  final String cartao;
  String token;

  UserEmprestimo(this.cliente, this.cpf, this.cartao);
}
