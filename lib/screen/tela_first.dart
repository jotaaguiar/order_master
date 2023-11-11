import 'package:flutter/material.dart';
import 'login_screen.dart';

class TelaFirst extends StatefulWidget {
  @override
  _TelaFirstState createState() => _TelaFirstState();
}

class _TelaFirstState extends State<TelaFirst> {
  @override
  void initState() {
    super.initState();
    // Adicione um delay de 2 segundos antes de navegar para a tela LoginScreen
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCCAA7D), // Cor de fundo
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset('images/LogoOrderMasterFinal.png', width: 200, height: 200),
            ),
          ],
        ),
      ),
    );
  }
}
