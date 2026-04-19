import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  TextEditingController usuario = TextEditingController();
  TextEditingController correo  = TextEditingController();
  TextEditingController contra  = TextEditingController();
  TextEditingController contra2 = TextEditingController();
  bool _cargando     = false;
  bool _contraOculta = true;

  Future<void> registrarse() async {
    if (usuario.text.isEmpty || correo.text.isEmpty ||
        contra.text.isEmpty  || contra2.text.isEmpty) {
      Toast.show("Rellena todos los campos");
      return;
    }

    if (contra.text != contra2.text) {
      Toast.show("Las contraseñas no coinciden");
      return;
    }

    if (contra.text.length < 6) {
      Toast.show("La contraseña debe tener al menos 6 caracteres");
      return;
    }

    if (!correo.text.contains("@")) {
      Toast.show("El correo no es válido");
      return;
    }

    setState(() => _cargando = true);

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2/asupark/registro.php"),
        body: {
          "NOMBRE_USUARIO": usuario.text,
          "CORREO_USUARIO": correo.text,
          "CONTRA_USUARIO": contra.text,
        },
      );

      if (response.body.trim() == "CORRECTO") {
        Toast.show("¡Cuenta creada! Ya puedes iniciar sesión");
        Navigator.pop(context);
      } else if (response.body.trim() == "EXISTE") {
        Toast.show("Ese usuario o correo ya está registrado");
      } else {
        Toast.show("Error al crear la cuenta");
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
      appBar: AppBar(
        backgroundColor: Color(0xFF1B2A4A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'CREAR CUENTA',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            children: [

              // Image.asset('assets/images/logo.png', height: 80),
              Icon(Icons.speed, color: Color(0xFFFFD700), size: 60),
              SizedBox(height: 32),

              _campo(controller: usuario, label: 'Nombre de piloto', icono: Icons.person),
              SizedBox(height: 16),
              _campo(controller: correo, label: 'Correo electrónico', icono: Icons.email, teclado: TextInputType.emailAddress),
              SizedBox(height: 16),
              _campo(
                controller: contra,
                label: 'Contraseña',
                icono: Icons.lock,
                oculto: _contraOculta,
                sufijo: IconButton(
                  icon: Icon(
                    _contraOculta ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white38,
                  ),
                  onPressed: () => setState(() => _contraOculta = !_contraOculta),
                ),
              ),
              SizedBox(height: 16),
              _campo(controller: contra2, label: 'Repetir contraseña', icono: Icons.lock_outline, oculto: _contraOculta),
              SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _cargando ? null : registrarse,
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
                    'REGISTRARSE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _campo({
    required TextEditingController controller,
    required String label,
    required IconData icono,
    bool oculto = false,
    Widget? sufijo,
    TextInputType teclado = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: oculto,
      keyboardType: teclado,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white60),
        prefixIcon: Icon(icono, color: Color(0xFFFFD700)),
        suffixIcon: sufijo,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFFD700)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}