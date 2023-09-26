import 'package:flutter/material.dart';

class TelaConfig extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navegar para a tela "Sobre" quando o botão é pressionado
            Navigator.push(context, MaterialPageRoute(builder: (context) => TelaSobre()));
          },
          child: Text('Sobre'),
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
              'Desenvolvido por mim e por meu caro amigo Bernardo Prado, o tal do bzin para os íntimos.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}








