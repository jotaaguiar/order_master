import 'package:flutter/material.dart';
import 'tela_cardapio.dart';
import 'login_screen.dart';
import 'screen_add_table.dart';

class TelaConfig extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Defina a cor diretamente como verde
    Color backgroundColor = Color(0xFFA2836E);

    // Defina o estilo de fonte desejado
    TextStyle buttonTextStyle = TextStyle(fontFamily: 'Arial', fontWeight: FontWeight.w400 , fontSize: 15.0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações', style: TextStyle(color: Colors.white)),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildButton(context, 'Sobre', TelaSobre(), textSize: 18.0, textStyle: buttonTextStyle),
          Divider(color: Color.fromARGB(255, 209, 209, 209), height: 0), // Linha divisória
          _buildButton(context, 'Configuração Cardápio', TelaCardapio(), textStyle: buttonTextStyle),
          Divider(color: Color.fromARGB(255, 209, 209, 209), height: 0),
          _buildButton(context, 'Configuração Salão', ScreenAddTable(), textStyle: buttonTextStyle),
          Divider(color: Color.fromARGB(255, 209, 209, 209), height: 0),
          _buildButton(context, 'Sair', LoginScreen(),textStyle: buttonTextStyle),
          Divider(color: Color.fromARGB(255, 209, 209, 209), height: 0),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String label,
    Widget screen, {
    Color? textColor,
    double? textSize,
    TextStyle? textStyle,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.white, // Cor de fundo branca
        onPrimary: Colors.black, // Cor do texto preto
        elevation: 0.0, // Sem elevação
        padding: EdgeInsets.all(16.0),
        minimumSize: Size(double.infinity, 50.0), // Largura total da tela
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: textStyle ?? TextStyle(fontSize: textSize ?? 16.0, color: textColor ?? Colors.black),
        ),
      ),
    );
  }
}

class TelaSobre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sobre o Aplicativo',
          style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'Arial', fontWeight: FontWeight.normal),
        ),
        backgroundColor: Color(0xFFA2836E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Este é um aplicativo que funciona como uma comanda de um bar ou restaurante, com todas as funcionalidades necessárias para que possa ser bem administrado.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Desenvolvido por João Paulo Prado e por meu caro amigo Bernardo Prado.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
