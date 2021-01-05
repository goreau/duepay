import 'package:duepay/util/routes.dart';
import 'package:duepay/views/extrato.dart';
import 'package:duepay/views/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          Routes.LOGIN: (_) => Login(),
          Routes.EXTRATO: (_) => Extrato(),
        },
        home: Scaffold(
            appBar: AppBar(title: Text('User Login Form')),
            body: Center(child: Login())));
  }
}
