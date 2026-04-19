import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'inicio.dart';
import 'registro.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usuario = TextEditingController();
  TextEditingController contra = TextEditingController();
  bool _cargando = false;
  bool _contraOculta = true;

  Future<void> iniciarSesion() async {
    if (usuario.text.isEmpty || contra.text.isEmpty) {
      Toast.show("Rellena todos los campos");
      return;
    }

    setState(() => _cargando = true);

    try {
      var url = "http://10.0.2.2/asupark/usuarios.php";
      final response = await http.post(Uri.parse(url), body: {
        "NOMBRE_USUARIO": usuario.text,
        "CONTRA_USUARIO": contra.text,
      });

      if (response.body.trim() == "CORRECTO") {
        Toast.show("¡Bienvenido!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Inicio(usuario: usuario.text)),
        );
      } else {
        Toast.show("Usuario o contraseña incorrectos");
      }
    } catch (e) {
      Toast.show("Error de conexión con el servidor");
    }

    setState(() => _cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Color(0xFF1B2A4A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Image.asset('assets/images/logo.png', height: 100),
                Icon(Icons.speed, color: Color(0xFFFFD700), size: 80),
                SizedBox(height: 8),
                Text(
                  'ASUPARK LAP TRACKER',
                  style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),

                SizedBox(height: 48),

                TextField(
                  controller: usuario,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    labelStyle: TextStyle(color: Colors.white60),
                    prefixIcon: Icon(Icons.person, color: Color(0xFFFFD700)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFFD700)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                TextField(
                  controller: contra,
                  obscureText: _contraOculta,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: Colors.white60),
                    prefixIcon: Icon(Icons.lock, color: Color(0xFFFFD700)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _contraOculta ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white38,
                      ),
                      onPressed: () =>
                          setState(() => _contraOculta = !_contraOculta),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFFD700)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _cargando ? null : iniciarSesion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFD700),
                      foregroundColor: Color(0xFF1B2A4A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _cargando
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF1B2A4A),
                      ),
                    )
                        : Text(
                      'ENTRAR',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistroPage()),
                  ),
                  child: Text(
                    '¿No tienes cuenta? Regístrate',
                    style: TextStyle(color: Colors.white38),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}