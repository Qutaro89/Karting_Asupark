import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistorialTab extends StatefulWidget {
  final String usuario;
  const HistorialTab({required this.usuario});

  @override
  _HistorialTabState createState() => _HistorialTabState();
}

class _HistorialTabState extends State<HistorialTab> {
  List _vueltas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    cargarHistorial();
  }

  Future<void> cargarHistorial() async {
    setState(() => _cargando = true);
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2/asupark/historial.php"),
        body: {"NOMBRE_USUARIO": widget.usuario},
      );
      setState(() {
        _vueltas = json.decode(response.body);
        _cargando = false;
      });
    } catch (e) {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String mejorTiempo = _vueltas.isNotEmpty ? _vueltas[0]["TIEMPO_VUELTA"] : "--:--";

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 24),
            Text("MIS VUELTAS",
                style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2)),
            SizedBox(height: 4),
            Text(widget.usuario,
                style: TextStyle(color: Colors.white54, fontSize: 13)),

            SizedBox(height: 20),

            // Tarjeta mejor tiempo
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Color(0xFFFFD700).withOpacity(0.3), width: 1),
              ),
              child: Column(
                children: [
                  Text("MEJOR VUELTA",
                      style: TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                          letterSpacing: 2)),
                  SizedBox(height: 8),
                  Text(mejorTiempo,
                      style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace')),
                  SizedBox(height: 4),
                  Text("${_vueltas.length} vueltas registradas",
                      style: TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Cabecera
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Text("FECHA",
                          style: TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1))),
                  Text("TIEMPO",
                      style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1)),
                ],
              ),
            ),

            SizedBox(height: 4),

            // Lista de vueltas
            Expanded(
              child: _cargando
                  ? Center(
                  child: CircularProgressIndicator(
                      color: Color(0xFFFFD700)))
                  : _vueltas.isEmpty
                  ? Center(
                  child: Text("Aún no tienes vueltas registradas",
                      style: TextStyle(color: Colors.white38)))
                  : ListView.builder(
                itemCount: _vueltas.length,
                itemBuilder: (context, index) {
                  final v = _vueltas[index];
                  bool esMejor = index == 0;
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 2),
                    padding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: esMejor
                          ? Colors.white12
                          : Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(8),
                      border: esMejor
                          ? Border.all(
                          color: Color(0xFFFFD700)
                              .withOpacity(0.3),
                          width: 1)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            v["FECHA_HORA_VUELTA"],
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: 13),
                          ),
                        ),
                        Text(
                          v["TIEMPO_VUELTA"],
                          style: TextStyle(
                            color: esMejor
                                ? Color(0xFFFFD700)
                                : Colors.white70,
                            fontWeight: esMejor
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}