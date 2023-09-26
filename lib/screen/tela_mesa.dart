import 'package:flutter/material.dart';
import 'tela_inserir.dart';
import 'tela_alterar.dart';
import 'tela_visualizar.dart';
import 'tela_conta.dart';

class TelaMesa extends StatelessWidget {
  final String numeroMesa;

  TelaMesa({required this.numeroMesa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$numeroMesa',
          style: TextStyle(color: Colors.white), // Cor do texto em preto
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OpcaoMesaBotao(
              texto: 'Inserir Pedido',
              telaDestino: TelaInserir(numeroMesa: numeroMesa), // Define a tela de destino
            ),
            SizedBox(height: 16),
            OpcaoMesaBotao(
              texto: 'Alterar Pedido',
              //telaDestino: TelaAlterar(numeroMesa: numeroMesa), // Define a tela de destino
            ),
            SizedBox(height: 16),
            OpcaoMesaBotao(
              texto: 'Visualizar Conta',
              //telaDestino: TelaVisualizar(), // Define a tela de destino
            ),
            SizedBox(height: 16),
            OpcaoMesaBotao(
              texto: 'Fechar Conta',
              corBotao: Colors.red, // Cor diferente para "Fechar Conta"
              //telaDestino: TelaConta(numeroMesa: numeroMesa), // Define a tela de destino
            ),
          ],
        ),
      ),
    );
  }
}

class OpcaoMesaBotao extends StatelessWidget {
  final String texto;
  final Color? corBotao; // Cor personalizada para o botão
  final Widget? telaDestino; // Tela de destino

  OpcaoMesaBotao({required this.texto, this.corBotao, this.telaDestino});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (telaDestino != null) {
          // Navegar para a tela de destino se estiver definida
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => telaDestino!),
          );
        } else {
          // Implemente a ação correspondente aqui para "Fechar Conta"
        }
      },
      style: ElevatedButton.styleFrom(
        primary: corBotao ?? Colors.blue, // Cor personalizada ou padrão
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
