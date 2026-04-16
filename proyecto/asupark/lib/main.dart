import 'package:flutter/material.dart';

import 'dart:async';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

void main() => runApp(loginApp());

class loginApp extends StateLessWidget{
@override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loginPage(),
    );
}

class LoginPage extends StatefulWidget {
    @override
    _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usuario = new TextEditingController();
  TextEditingController contra = new TextEditingController();
  
  Future<List> obtenerDatos() async{
    var url = "http://127.0.0.1/asupark/usuarios.php";
    final response = await http.post(url, body: {
      "NOMBRE_USUARIO": usuario.text,
      "CONTRA_USUARIO": contra.text,
    });
    if(response.body == "CORRECTO"){
      oast.show(
        "LOGIN CORRECTO",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
      );
      // ir a la pagina de inicio
    }else if(response.body == "ERROR"){
      Toast.show(
        "LOGIN INCORRECTO",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
      );
    }
  }
  // UI de la pagina de login
}








