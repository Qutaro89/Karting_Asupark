import 'package:flutter/material.dart';

class login extends StatelessWidget{
    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: new AppBar(title: new Text('Login'),),
            body: new Column(
                children: <Widget>[
                    new Text("Página de Login")
                ]
            )
        );
    }
}