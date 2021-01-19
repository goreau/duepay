import 'dart:convert';
import 'package:duepay/comunicacao/emprestimo_dao.dart';
import 'package:duepay/models/proposta.dart';
import 'package:duepay/models/usuario.dart';
import 'package:duepay/util/storage.dart';
import 'package:flutter/cupertino.dart';

class EmprestimoProvider with ChangeNotifier {
  List<LstProposta> _itens;

  EmprestimoProvider() {
    loadItens();
  }

  void inicio() async {
    await loadItens();
  }

  Future<void> loadItens() async {
    try {
      Usuario user = Usuario.fromJson(await Storage.recupera("user"));
      final resp = jsonDecode(await EmprestimoDao.consultaPropostas(user));

      if (resp['success']) {
        var tagObjsJson = resp['lista'] as List;
        _itens = tagObjsJson
            .map((tagJson) => LstProposta.fromJson(tagJson))
            .toList();
      }
    } catch (Excepetion) {
      print('fodeu no provider' + Excepetion.toString());
    }
  }

  List<LstProposta> get all {
    return [..._itens];
  }

  int get count {
    return _itens.length;
  }

  LstProposta byIndex(int i) {
    return _itens.elementAt(i);
  }
}
