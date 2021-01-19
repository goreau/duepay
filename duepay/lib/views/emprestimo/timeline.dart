import 'dart:convert';

import 'package:duepay/comunicacao/emprestimo_dao.dart';
import 'package:duepay/models/usuario.dart';
import 'package:duepay/models/proposta.dart';
import 'package:duepay/util/routes.dart';
import 'package:duepay/util/storage.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Timeline extends StatefulWidget {
  @override
  _Timelinetate createState() => _Timelinetate();
}

class _Timelinetate extends State<Timeline> {
  Usuario logUser;
  Proposta proposta = Proposta(0, 0, '', '', '', '', '', '', 0, '', 0, '');
  int _ccb;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    _ccb = ModalRoute.of(context).settings.arguments;
  }

  loadUser() async {
    try {
      Usuario user = Usuario.fromJson(await Storage.recupera("user"));
      Proposta prop;
      if (_ccb > 0) {
        var data = jsonEncode({
          'post': {
            'ccb': _ccb,
          }
        });
        final resp = jsonDecode(await EmprestimoDao.dadosProposta(data, user));
        prop = Proposta.fromJson(resp['docs']);
      }

      setState(() {
        logUser = user;
        if (prop != null) {
          proposta = prop;
        }
      });
    } catch (Excepetion) {
      print('fodeu' + Excepetion.toString());
    }
  }

  loadRota(String rota) {
    Navigator.of(context).pushNamed(rota).whenComplete(() => loadUser());
  }

  @override
  Widget build(BuildContext context) {
    Color inativo = Colors.green.shade500;
    Color ativo = Colors.grey;
    return Scaffold(
      appBar: AppBar(
        title: Text('Empréstimo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.1,
                    isFirst: true,
                    indicatorStyle: IndicatorStyle(
                      width: 30,
                      color: proposta.status > 1 ? inativo : ativo,
                      padding: const EdgeInsets.all(8),
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: Icons.star,
                      ),
                    ),
                    afterLineStyle:
                        LineStyle(color: proposta.status > 1 ? inativo : ativo),
                    endChild: Content(
                        '1. Escolha a melhor opção',
                        proposta.status > 1,
                        proposta.time1,
                        Routes.EMP_SIMULA,
                        loadRota),
                  ),
                  TimelineDivider(
                    begin: 0.1,
                    end: 0.9,
                    color: proposta.status > 1 ? inativo : ativo,
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.9,
                    isFirst: false,
                    indicatorStyle: IndicatorStyle(
                      width: 30,
                      color: proposta.status > 2 ? inativo : ativo,
                      padding: const EdgeInsets.all(8),
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: Icons.star,
                      ),
                    ),
                    beforeLineStyle:
                        LineStyle(color: proposta.status > 1 ? inativo : ativo),
                    afterLineStyle:
                        LineStyle(color: proposta.status > 2 ? inativo : ativo),
                    startChild: Content(
                        '2. Consultar sua proposta.',
                        proposta.status > 2,
                        proposta.time2,
                        Routes.EMP_CONSULTA,
                        loadRota),
                  ),
                  TimelineDivider(
                      begin: 0.1,
                      end: 0.9,
                      color: proposta.status > 2 ? inativo : ativo),
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.1,
                    isFirst: false,
                    indicatorStyle: IndicatorStyle(
                      width: 30,
                      color: proposta.status > 3 ? inativo : ativo,
                      padding: const EdgeInsets.all(8),
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: Icons.star,
                      ),
                    ),
                    beforeLineStyle:
                        LineStyle(color: proposta.status > 2 ? inativo : ativo),
                    afterLineStyle:
                        LineStyle(color: proposta.status > 3 ? inativo : ativo),
                    endChild: Content(
                        '3. Solicitar link para assinatura do contrato.',
                        proposta.status > 3,
                        proposta.time3,
                        Routes.EMP_CONSULTA,
                        loadRota),
                  ),
                  TimelineDivider(
                      begin: 0.1,
                      end: 0.9,
                      color: proposta.status > 3 ? inativo : ativo),
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.9,
                    isFirst: false,
                    indicatorStyle: IndicatorStyle(
                      width: 30,
                      color: proposta.status > 4 ? inativo : ativo,
                      padding: const EdgeInsets.all(8),
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: Icons.star,
                      ),
                    ),
                    beforeLineStyle:
                        LineStyle(color: proposta.status > 3 ? inativo : ativo),
                    afterLineStyle:
                        LineStyle(color: proposta.status > 4 ? inativo : ativo),
                    startChild: Content(
                        '4. Assinar o contrato.',
                        proposta.status > 4,
                        proposta.time4,
                        Routes.EMP_CONSULTA,
                        loadRota),
                  ),
                  TimelineDivider(
                      begin: 0.1,
                      end: 0.9,
                      color: proposta.status > 4 ? inativo : ativo),
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.1,
                    isLast: true,
                    indicatorStyle: IndicatorStyle(
                      width: 30,
                      color: proposta.status > 5 ? inativo : ativo,
                      padding: const EdgeInsets.all(8),
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: Icons.star,
                      ),
                    ),
                    beforeLineStyle:
                        LineStyle(color: proposta.status > 4 ? inativo : ativo),
                    endChild: Content('5. Valor liberado.', proposta.status > 5,
                        proposta.time5, Routes.EMP_CONSULTA, loadRota),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Content extends StatelessWidget {
  final String title;
  final bool done;
  final String hora;
  final String rota;
  final Function f;

  Content(this.title, this.done, this.hora, this.rota, this.f);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Colors.grey[100],
        child: InkWell(
          onTap: () {
            if (!done) {
              f(rota);
            }
          },
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: done
                      ? Text(
                          formataData(hora),
                          style: TextStyle(
                              color: Colors.green.shade600, fontSize: 12),
                        )
                      : Text(''),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formataData(String date) {
    if (date == '') {
      return '';
    } else {
      var partes = date.split(' ');
      var dateParse = DateTime.parse(partes[0]);

      var formattedDate =
          "${dateParse.day}-${dateParse.month}-${dateParse.year}";
      return 'Concluído em $formattedDate ${partes[1].substring(0, 8)}';
    }
  }
}
