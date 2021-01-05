import 'dart:convert';
import 'package:duepay/comunicacao/comunica.dart';
import 'package:duepay/models/usuario.dart';
import 'package:duepay/views/inicio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  // For CircularProgressIndicator.
  bool visible = false;
  Usuario user;

  // Getting value from TextField widget.
  final usuarioController = TextEditingController();
  final senhaController = TextEditingController();

  Future userLogin() async {
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    String usuario = usuarioController.text;
    String senha = senhaController.text;

    /*/ SERVER LOGIN API URL
    var url = 'login/authentication';

    // Store all data with Param Name.
    var data = {'usuario': email, 'senha': password};

    // Starting Web API Call.
    var response = await http.post(url,
        body: json.encode(data), headers: {'Content-Type': 'application/json'});*/

    Comunica com = Comunica();

    // Getting Server response into variable.
    var message = jsonDecode(await com.login(usuario, senha));

    // If the Response Message is Matched.
    if (message['success']) {
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      var ret = message['usuario'];
      user = Usuario(ret['id'], ret['usuario'], ret['nome'], ret['sobrenome'],
          ret['perfil'], ret['status'], ret['cartao_corporativo']);
      // Navigate to Profile Screen & Sending Email to Next Screen.
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Inicio(user: user)));
    } else {
      // If Email or Password did not Matched.
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      // Showing Alert Dialog with Response JSON Message.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(message),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    usuarioController.text = '63608503201821138';
    senhaController.text = '3798514';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Center(
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('User Login Form', style: TextStyle(fontSize: 21))),
          Divider(),
          Container(
              width: 280,
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: usuarioController,
                autocorrect: true,
                decoration: InputDecoration(hintText: 'Nº do Cartão'),
              )),
          Container(
              width: 280,
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: senhaController,
                autocorrect: true,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Senha Web'),
              )),
          RaisedButton(
            onPressed: userLogin,
            color: Colors.green,
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
            child: Text('Entrar'),
          ),
          Visibility(
              visible: visible,
              child: Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: CircularProgressIndicator())),
        ],
      ),
    )));
  }
}
