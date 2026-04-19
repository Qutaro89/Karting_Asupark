import 'package:flutter/material.dart';
import 'pages/login.dart';

void main() => runApp(LoginApp());

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asupark',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF1B2A4A),
        scaffoldBackgroundColor: Color(0xFF1B2A4A),
      ),
      home: LoginPage(),
    );
  }
}