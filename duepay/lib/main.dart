import 'package:duepay/util/routes.dart';
import 'package:duepay/views/emprestimo.dart';
import 'package:duepay/views/emprestimo/consulta.dart';
import 'package:duepay/views/emprestimo/simulacao.dart';
import 'package:duepay/views/emprestimo/timeline.dart';
import 'package:duepay/views/extrato.dart';
import 'package:duepay/views/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const cor = Color.fromRGBO(255, 230, 204, 100);
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          //primarySwatch: Colors.brown,
          brightness: Brightness.light,
          primaryColor: Color.fromRGBO(243, 208, 155, 1),
          accentColor: Color.fromRGBO(57, 72, 87, 1),

          // Define the default font family.
          fontFamily: 'Arial',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText1: TextStyle(fontSize: 12.0, fontFamily: 'Hind'),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
        routes: {
          Routes.LOGIN: (_) => Login(),
          Routes.EXTRATO: (_) => Extrato(),
          Routes.EMPRESTIMO: (_) => Emprestimo(),
          Routes.EMP_TIMELINE: (_) => Timeline(),
          Routes.EMP_SIMULA: (_) => Simulacao(),
          Routes.EMP_CONSULTA: (_) => Consulta(),
        },
        home: Scaffold(
            appBar: AppBar(title: Text('Login')),
            body: Center(child: Login())));
  }
}
