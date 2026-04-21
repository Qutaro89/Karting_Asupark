import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List _tiempos = [];
  bool _cargando = true;
  String _filtro = "HOY";
  String _busqueda = "";
  bool _ordenAscendente = true;
  TextEditingController _buscador = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarTiempos();
  }

  Future<void> cargarTiempos() async {
    setState(() => _cargando = true);
    try {
      final response = await http.post(
        // hay que cambiar la ip por la ip del servidor (con la ip 10.0.2.2 solo funcionaria en el emulador)
        Uri.parse("http://10.0.2.2/asupark/tiempos.php"),
        body: {"TIPO": _filtro},
      );
      setState(() {
        _tiempos = json.decode(response.body);
        _cargando = false;
      });
    } catch (e) {
      setState(() => _cargando = false);
    }
  }

  List get _tiemposFiltrados {
    List resultado = _tiempos.where((t) {
      return t["NOMBRE_USUARIO"]
          .toString()
          .toLowerCase()
          .contains(_busqueda.toLowerCase());
    }).toList();

    resultado.sort((a, b) => _ordenAscendente
        ? a["TIEMPO_VUELTA"].compareTo(b["TIEMPO_VUELTA"])
        : b["TIEMPO_VUELTA"].compareTo(a["TIEMPO_VUELTA"]));

    return resultado;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [

            SizedBox(height: 16),

            // Selector HOY / GLOBAL
            Row(
              children: ["HOY", "GLOBAL"].map((opcion) {
                bool activo = _filtro == opcion;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _filtro = opcion);
                      cargarTiempos();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: activo ? Color(0xFFFFD700) : Colors.white10,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        opcion == "HOY" ? "MEJORES DE HOY" : "RANKING GLOBAL",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: activo ? Color(0xFF1B2A4A) : Colors.white54,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Buscador
            TextField(
              controller: _buscador,
              style: TextStyle(color: Colors.white),
              onChanged: (v) => setState(() => _busqueda = v),
              decoration: InputDecoration(
                hintText: 'Buscar piloto...',
                hintStyle: TextStyle(color: Colors.white38),
                prefixIcon: Icon(Icons.search, color: Color(0xFFFFD700)),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            SizedBox(height: 12),

            // Cabecera tabla
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  SizedBox(width: 32),
                  Expanded(
                    child: Text("PILOTO",
                        style: TextStyle(
                            color: Color(0xFFFFD700),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1)),
                  ),
                  GestureDetector(
                    onTap: () => setState(
                            () => _ordenAscendente = !_ordenAscendente),
                    child: Row(
                      children: [
                        Text("TIEMPO",
                            style: TextStyle(
                                color: Color(0xFFFFD700),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1)),
                        SizedBox(width: 4),
                        Icon(
                          _ordenAscendente
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: Color(0xFFFFD700),
                          size: 14,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 4),

            // Lista
            Expanded(
              child: _cargando
                  ? Center(
                  child: CircularProgressIndicator(
                      color: Color(0xFFFFD700)))
                  : _tiemposFiltrados.isEmpty
                  ? Center(
                  child: Text("Sin resultados",
                      style: TextStyle(color: Colors.white38)))
                  : ListView.builder(
                itemCount: _tiemposFiltrados.length,
                itemBuilder: (context, index) {
                  final t = _tiemposFiltrados[index];
                  bool esPrimero = index == 0;
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 2),
                    padding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: esPrimero
                          ? Colors.white12
                          : Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(8),
                      border: esPrimero
                          ? Border.all(
                          color: Color(0xFFFFD700)
                              .withOpacity(0.4),
                          width: 1)
                          : null,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 32,
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: esPrimero
                                  ? Color(0xFFFFD700)
                                  : Colors.white38,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            t["NOMBRE_USUARIO"],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: esPrimero
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          t["TIEMPO_VUELTA"],
                          style: TextStyle(
                            color: esPrimero
                                ? Color(0xFFFFD700)
                                : Colors.white70,
                            fontWeight: esPrimero
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