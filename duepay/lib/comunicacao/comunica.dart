import 'dart:convert';
import 'package:duepay/util/routes.dart';
import 'package:duepay/util/storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Comunica {
  static final server = 'http://10.0.2.2:82/';
  //static final server = 'https://apihomologa.duebank.com.br/';

  static Future<String> login(String usuario, String senha) async {
    var url = server + 'login/authentication';

    // Store all data with Param Name.
    var data = {'usuario': usuario, 'senha': senha};

    // Starting Web API Call.
    var response = await http.post(url,
        body: json.encode(data), headers: {'Content-Type': 'application/json'});

    return response.body;
  }

  static bool checkToken(Response resp) {
    if (resp.statusCode == 401) {
      Storage.remove('user');
      //Navigator.of(context).pushNamed(Routes.EXTRATO);
      return false;
    }
    return true;
  }
}
