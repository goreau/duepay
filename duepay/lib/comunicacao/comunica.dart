import 'dart:convert';

import 'package:http/http.dart' as http;

class Comunica {
  final server = 'http://10.0.2.2:82/';

  Future<String> login(String usuario, String senha) async {
    var url = server + 'login/authentication';

    // Store all data with Param Name.
    var data = {'usuario': usuario, 'senha': senha};

    // Starting Web API Call.
    var response = await http.post(url,
        body: json.encode(data), headers: {'Content-Type': 'application/json'});

    return response.body;
  }
}
