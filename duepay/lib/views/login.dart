import 'dart:convert';
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

  // Getting value from TextField widget.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future userLogin() async {
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    String email = emailController.text;
    String password = passwordController.text;
/*
    // SERVER LOGIN API URL
    var url = 'https://flutter-examples.000webhostapp.com/login_user.php';

    // Store all data with Param Name.
    var data = {'email': email, 'password': password};

    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);
*/
    var message = 'Login Matched';
    // If the Response Message is Matched.
    if (message == 'Login Matched') {
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      // Navigate to Profile Screen & Sending Email to Next Screen.
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Inicio(usuario: emailController.text)));
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
                controller: emailController,
                autocorrect: true,
                decoration: InputDecoration(hintText: 'Enter Your Email Here'),
              )),
          Container(
              width: 280,
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: passwordController,
                autocorrect: true,
                obscureText: true,
                decoration:
                    InputDecoration(hintText: 'Enter Your Password Here'),
              )),
          RaisedButton(
            onPressed: userLogin,
            color: Colors.green,
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
            child: Text('Click Here To Login'),
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
