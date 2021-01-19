import 'dart:convert';

import 'package:duepay/comunicacao/comunica.dart';
import 'package:duepay/models/usuario.dart';
import 'package:duepay/views/emprestimo/simulacao.dart';
import 'package:http/http.dart' as http;

class EmprestimoDao extends Comunica {
  static final server = Comunica.server;

  static Future<String> getSaldo(Usuario user) async {
    var url = server + 'bank/getsaldousuarioemprestimo';
    var header = {
      'Content-Type': 'application/json',
      'X-Auth-Token-Update': user.token
    };

    var response = await http.get(url, headers: header);

    return response.body;
  }

  static Future<String> getParcelas(double valor, UserEmprestimo user) async {
    var url = server + 'bank/getparcelas';

    // Store all data with Param Name.
    var data = {
      'valor': {
        'val': {'valor': valor, 'cartao': user.cartao, 'cpf': user.cpf}
      }
    };
    var header = {
      'Content-Type': 'application/json',
      'X-Auth-Token-Update': user.token
    };

    // Starting Web API Call.
    var response =
        await http.post(url, body: json.encode(data), headers: header);

    bool test = Comunica.checkToken(response);
    print(response.statusCode);

    return response.body;
  }

  static Future<String> getTabela(String dados, Usuario user) async {
    var url = server + 'emprestimo/simula';

    // Store all data with Param Name.
    // var data = dados;
    var header = {
      'Content-Type': 'application/json',
      'X-Auth-Token-Update': user.token
    };

    // Starting Web API Call.
    var response = await http.post(url, body: dados, headers: header);

    return response.body;
  }

  static Future<String> putBanco(String dados, Usuario user) async {
    var url = server + 'bank/gravaproposta';

    // Store all data with Param Name.
    // var data = dados;
    var header = {
      'Content-Type': 'application/json',
      'X-Auth-Token-Update': user.token
    };

    // Starting Web API Call.
    var response = await http.post(url, body: dados, headers: header);

    return response.body;
  }

  static Future<String> empenhoTelenet(String dados, Usuario user) async {
    var url = server + 'bank/solicitapagamento';

    // Store all data with Param Name.
    // var data = dados;
    var header = {
      'Content-Type': 'application/json',
      'X-Auth-Token-Update': user.token
    };

    // Starting Web API Call.
    var response = await http.post(url, body: dados, headers: header);

    return response.body;
  }

  static Future<String> importaOperacao(String dados, Usuario user) async {
    var url = server + 'emprestimo/importar';

    // Store all data with Param Name.
    // var data = dados;
    var header = {
      'Content-Type': 'application/json',
      'X-Auth-Token-Update': user.token
    };

    // Starting Web API Call.
    var response = await http.post(url, body: dados, headers: header);

    return response.body;
  }

  static Future<String> updateProposta(String dados, Usuario user) async {
    var url = server + 'bank/updateproposta';

    // Store all data with Param Name.
    // var data = dados;
    var header = {
      'Content-Type': 'application/json',
      'X-Auth-Token-Update': user.token
    };

    // Starting Web API Call.
    var response = await http.post(url, body: dados, headers: header);

    return response.body;
  }

  static Future<String> removeProposta(String dados, Usuario user) async {
    var url = server + 'bank/excluiproposta';

    // Store all data with Param Name.
    // var data = dados;
    var header = {
      'Content-Type': 'application/json',
      'X-Auth-Token-Update': user.token
    };

    // Starting Web API Call.
    var response = await http.post(url, body: dados, headers: header);

    return response.body;
  }

  static Future<String> dadosProposta(String dados, Usuario user) async {
    var url = server + 'bank/documentosproposta';

    // Store all data with Param Name.
    // var data = dados;
    var header = {
      'Content-Type': 'application/json',
      'X-Auth-Token-Update': user.token
    };

    // Starting Web API Call.
    var response = await http.post(url, body: dados, headers: header);

    return response.body;
  }

  static Future<String> consultaPropostas(Usuario user) async {
    var url = server + 'bank/consultaproposta';

    // Store all data with Param Name.
    // var data = dados;
    var header = {
      'Content-Type': 'application/json',
      'X-Auth-Token-Update': user.token
    };

    // Starting Web API Call.
    var response = await http.get(url, headers: header);

    return response.body;
  }
}
