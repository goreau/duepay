import 'package:duepay/models/usuario.dart';
import 'package:http/http.dart' as http;

class EmprestimoDao {
  //static final server = 'http://10.0.2.2:82/';
  static final server = 'https://api.duebank.com.br/';

  static Future<String> getSaldo(Usuario user) async {
    var url = server + 'bank/getsaldousuarioemprestimo';

    // Store all data with Param Name.
    var header = {
      'Content-Type': 'application/json',
      'X-Auth-Token-Update': user.token
    };
    var data = {'usuario': user.usuario, 'senha': user.senha};

    // Starting Web API Call.
    var response = await http.get(url, headers: header);

    return response.body;
  }
}
