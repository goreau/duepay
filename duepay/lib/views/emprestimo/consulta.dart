import 'package:duepay/components/emprestimo_tile.dart';
import 'package:duepay/models/usuario.dart';
import 'package:duepay/provider/emprestimo_provider.dart';
import 'package:duepay/util/storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsultaEmprestimo extends StatelessWidget {
  Usuario user;

  loadUser() async {
    try {
      user = Usuario.fromJson(await Storage.recupera("user"));
    } catch (Excepetion) {
      print('fodeu' + Excepetion.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    loadUser();
    final EmprestimoProvider emps = Provider.of(context);
    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Propostas realizadas'),
          ),
          body: ListView.builder(
            itemCount: emps.count,
            itemBuilder: (ctx, i) => EmprestimoTile(emps.byIndex(i)),
          ),
        );
      },
    );
  }
}
