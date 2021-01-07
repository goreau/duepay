import 'package:duepay/models/usuario.dart';
import 'package:duepay/util/routes.dart';
import 'package:duepay/util/storage.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Emprestimo extends StatefulWidget {
  @override
  _EmprestimoState createState() => _EmprestimoState();
}

class _EmprestimoState extends State<Emprestimo> {
  Usuario logUser;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  loadUser() async {
    try {
      Usuario user = Usuario.fromJson(await Storage.recupera("user"));
      setState(() {
        logUser = user;
      });
    } catch (Excepetion) {
      print('fodeu' + Excepetion.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Empréstimo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Text(logUser.token),
            Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.1,
                    isFirst: true,
                    indicatorStyle: IndicatorStyle(
                      width: 30,
                      color: Colors.grey,
                      padding: const EdgeInsets.all(8),
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: Icons.star,
                      ),
                    ),
                    endChild: Container(
                      child: Card(
                        color: Colors.grey[100],
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.EMP_SIMULA);
                          },
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text('1. Escolha a melhor opção.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(''),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TimelineDivider(
                    begin: 0.1,
                    end: 0.9,
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.9,
                    isFirst: false,
                    indicatorStyle: IndicatorStyle(
                      width: 30,
                      color: Colors.grey,
                      padding: const EdgeInsets.all(8),
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: Icons.star,
                      ),
                    ),
                    startChild: Container(
                      child: Card(
                        color: Colors.grey[100],
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(Routes.EMP_CONSULTA);
                          },
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text('2. Consultar sua proposta.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(''),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TimelineDivider(
                    begin: 0.1,
                    end: 0.9,
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.1,
                    isFirst: false,
                    indicatorStyle: IndicatorStyle(
                      width: 30,
                      color: Colors.grey,
                      padding: const EdgeInsets.all(8),
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: Icons.star,
                      ),
                    ),
                    endChild: Container(
                      child: Card(
                        color: Colors.grey[100],
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                      '3. Solicitar link para assinatura do contrato.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(''),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TimelineDivider(
                    begin: 0.1,
                    end: 0.9,
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.9,
                    isFirst: false,
                    indicatorStyle: IndicatorStyle(
                      width: 30,
                      color: Colors.grey,
                      padding: const EdgeInsets.all(8),
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: Icons.star,
                      ),
                    ),
                    startChild: Container(
                      child: Card(
                        color: Colors.grey[100],
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text('4. Escolha a melhor opção.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(''),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TimelineDivider(
                    begin: 0.1,
                    end: 0.9,
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.1,
                    isLast: true,
                    indicatorStyle: IndicatorStyle(
                      width: 30,
                      color: Colors.grey,
                      padding: const EdgeInsets.all(8),
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: Icons.star,
                      ),
                    ),
                    endChild: Container(
                      child: Card(
                        color: Colors.grey[100],
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text('5. Valor liberado.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(''),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
