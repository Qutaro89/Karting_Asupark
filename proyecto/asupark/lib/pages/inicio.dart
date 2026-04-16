import 'package:flutter/material.dart';

class inicio extends StatelessWidget{
    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: new AppBar(title: new Text('Inicio'),),
            body: new Column(
                children: <Widget>[
                    new Text("Página de inicio")
                ]
            )
        );
    }
}