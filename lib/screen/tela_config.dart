import 'package:flutter/material.dart';
import 'tela_cardapio.dart';
class TelaConfig extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
        backgroundColor: Colors.grey[800],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[600], // Cor de fundo cinza
                onPrimary: Colors.white, // Cor do texto branco
              ),
              onPressed: () {
                // Navegar para a tela "Sobre" quando o botão é pressionado
                Navigator.push(context, MaterialPageRoute(builder: (context) => TelaSobre()));
              },
              child: Text('Sobre'),
            ),
            SizedBox(height: 16.0), // Adicione espaço entre os botões
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[600], // Cor de fundo cinza
                onPrimary: Colors.white, // Cor do texto branco
              ),
              onPressed: () {
                // Navegar para a tela de adicionar itens ao cardápio
                Navigator.push(context, MaterialPageRoute(builder: (context) => TelaCardapio()));
              },
              child: Text('Configuração Cardápio'),
            ),
          ],
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
        title: Text('Sobre o Aplicativo'),
        backgroundColor: Colors.grey[800],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Adicione espaço ao redor do texto
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Este é um aplicativo que funciona como uma comanda de um bar ou restaurante, com todas as funcionalidades necessárias para que possa ser bem administrado.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 50.0), 
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








