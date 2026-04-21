import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';

class PerfilTab extends StatefulWidget {
  final String usuario;
  const PerfilTab({required this.usuario});

  @override
  _PerfilTabState createState() => _PerfilTabState();
}

class _PerfilTabState extends State<PerfilTab> {
  Map _datos = {};
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    cargarPerfil();
  }

  Future<void> cargarPerfil() async {
    setState(() => _cargando = true);
    try {
      final response = await http.post(
        // hay que cambiar la ip por la ip del servidor (con la ip 10.0.2.2 solo funcionaria en el emulador)
        Uri.parse("http://10.0.2.2/asupark/perfil.php"),
        body: {"NOMBRE_USUARIO": widget.usuario},
      );
      setState(() {
        _datos = json.decode(response.body);
        _cargando = false;
      });
    } catch (e) {
      setState(() => _cargando = false);
    }
  }

  void cerrarSesion() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _cargando
          ? Center(child: CircularProgressIndicator(color: Color(0xFFFFD700)))
          : SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [

            SizedBox(height: 32),

            // Avatar
            CircleAvatar(
              radius: 48,
              backgroundColor: Color(0xFFFFD700).withOpacity(0.15),
              child: Icon(Icons.person,
                  size: 56, color: Color(0xFFFFD700)),
            ),
            SizedBox(height: 16),
            Text(
              widget.usuario,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              _datos["CORREO_USUARIO"] ?? "",
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),

            SizedBox(height: 32),

            // Tarjetas de datos
            _tarjeta(Icons.email_outlined, "Correo",
                _datos["CORREO_USUARIO"] ?? "-"),
            SizedBox(height: 8),
            _tarjeta(Icons.calendar_today_outlined, "Miembro desde",
                _datos["FECHA_ALTA"] ?? "-"),
            SizedBox(height: 8),
            _tarjeta(Icons.flag_outlined, "Total de vueltas",
                "${_datos["TOTAL_VUELTAS"] ?? 0}"),
            SizedBox(height: 8),
            _tarjeta(Icons.timer_outlined, "Mejor vuelta",
                _datos["MEJOR_VUELTA"] ?? "--:--"),

            SizedBox(height: 40),

            // Botón cerrar sesión
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: cerrarSesion,
                icon: Icon(Icons.logout, color: Colors.white54),
                label: Text("Cerrar sesión",
                    style: TextStyle(color: Colors.white54)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _tarjeta(IconData icono, String titulo, String valor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icono, color: Color(0xFFFFD700), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(titulo,
                style: TextStyle(color: Colors.white54, fontSize: 13)),
          ),
          Text(valor,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}