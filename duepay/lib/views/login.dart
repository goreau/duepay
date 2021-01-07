import 'dart:convert';
import 'package:duepay/comunicacao/comunica.dart';
import 'package:duepay/models/usuario.dart';
import 'package:duepay/util/storage.dart';
import 'package:duepay/views/inicio.dart';
import 'package:flutter/material.dart';

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

    // Getting Server response into variable.
    var message = jsonDecode(await Comunica.login(usuario, senha));

    // If the Response Message is Matched.
    if (message['success']) {
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      var ret = message['usuario'];
      var tk = message['token'];
      user = Usuario(
        ret['id'],
        ret['usuario'],
        ret['nome'],
        ret['sobrenome'],
        ret['perfil'],
        ret['status'],
        ret['cartao_corporativo'],
        tk,
        senha,
      );

      Storage.insere('user', user.toJson());
      // Navigate to Profile Screen & Sending Email to Next Screen.
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Inicio(user: user)));
    } else {
      // If Email or Password did not Matched.
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });
      String ret = message['message'];
      String msg;
      //trata o retorno da função
      if (ret.indexOf('SQLSTATE') >= 0) {
        msg =
            'Problemas ao conectar com a base de dados. Tente novamente mais tarde.';
      } else {
        msg = ret;
      }

      // Showing Alert Dialog with Response JSON Message.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(msg),
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
    usuarioController.text = '63608503201329803'; //'63608503201807664';
    senhaController.text = '170882';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            width: 280,
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: usuarioController,
              autocorrect: true,
              decoration: InputDecoration(hintText: 'Nº do Cartão'),
              style: TextStyle(fontSize: 12),
            )),
        Divider(),
        Container(
            width: 280,
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: senhaController,
              autocorrect: true,
              obscureText: true,
              decoration: InputDecoration(hintText: 'Senha Web'),
              style: TextStyle(fontSize: 12),
            )),
        RaisedButton(
          onPressed: userLogin,
          color: Color.fromRGBO(57, 72, 87, 1),
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
          child: Text('Entrar'),
        ),
        Visibility(
          visible: visible,
          child: Container(
            margin: EdgeInsets.only(bottom: 30),
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    ));
  }
}
