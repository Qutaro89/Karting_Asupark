import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'historial_tab.dart';
import 'perfil_tab.dart';

class Inicio extends StatefulWidget {
  final String usuario;
  const Inicio({required this.usuario});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _paginaActual = 0;

  @override
  Widget build(BuildContext context) {
    final paginas = [
      HomeTab(),
      HistorialTab(usuario: widget.usuario),
      PerfilTab(usuario: widget.usuario),
    ];

    return Scaffold(
      backgroundColor: Color(0xFF1B2A4A),
      body: paginas[_paginaActual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaActual,
        onTap: (i) => setState(() => _paginaActual = i),
        backgroundColor: Color(0xFF0F1C32),
        selectedItemColor: Color(0xFFFFD700),
        unselectedItemColor: Colors.white30,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Mis vueltas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}