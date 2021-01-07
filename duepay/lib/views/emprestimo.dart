import 'package:duepay/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Emprestimo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Empréstimo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TimelineTile(
                    alignment: TimelineAlign.start,
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
                  TimelineTile(
                    alignment: TimelineAlign.start,
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
                  TimelineTile(
                    alignment: TimelineAlign.start,
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
                  TimelineTile(
                    alignment: TimelineAlign.start,
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
                  TimelineTile(
                    alignment: TimelineAlign.start,
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
