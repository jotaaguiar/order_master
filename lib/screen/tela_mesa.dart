import 'package:flutter/material.dart';
import 'tela_inserir.dart';
import 'tela_alterar.dart';
import 'tela_visualizar.dart';
import 'tela_conta.dart';

class TelaMesa extends StatefulWidget {
  final String numeroMesa;

  TelaMesa({required this.numeroMesa});

  @override
  _TelaMesaState createState() => _TelaMesaState();
}

class _TelaMesaState extends State<TelaMesa> {
  bool mesaOcupada = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.numeroMesa}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFA2836E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OpcaoMesaBotao(
              texto: 'Inserir Pedido',
              corBotao: Color(0xFFA2836E),
              telaDestino: TelaInserir(numeroMesa: widget.numeroMesa),
              width: 200, // Defina a largura desejada
              height: 50,  // Defina a altura desejada
            ),
            SizedBox(height: 10),
            OpcaoMesaBotao(
              texto: 'Alterar Pedido',
              corBotao: Color(0xFFA2836E),
              telaDestino: TelaAlterar(numeroMesa: widget.numeroMesa),
              width: 200, // Defina a largura desejada
              height: 50,  // Defina a altura desejada
            ),
            SizedBox(height: 10),
            OpcaoMesaBotao(
              texto: 'Visualizar Conta',
              corBotao: Color(0xFFA2836E),
              telaDestino: TelaVisualizar(numeroMesa: widget.numeroMesa),
              width: 200, // Defina a largura desejada
              height: 50,  // Defina a altura desejada
            ),
            SizedBox(height: 10),
            OpcaoMesaBotao(
              texto: 'Fechar Conta',
              corBotao: Colors.red,
              telaDestino: TelaConta(numeroMesa: widget.numeroMesa),
              width: 200, // Defina a largura desejada
              height: 50,  // Defina a altura desejada
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void marcarOcupacao(bool ocupada) {
    // Implemente a lógica para marcar a ocupação no banco de dados aqui
    setState(() {
      mesaOcupada = ocupada;
    });
  }
}

class OpcaoMesaBotao extends StatelessWidget {
  final String texto;
  final Color? corBotao;
  final Widget? telaDestino;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  OpcaoMesaBotao({
    required this.texto,
    this.corBotao,
    this.telaDestino,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (telaDestino != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => telaDestino!),
          );
        } else if (onTap != null) {
          onTap!();
        }
      },
      style: ElevatedButton.styleFrom(
        primary: corBotao ?? Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        fixedSize: Size(width ?? double.infinity, height ?? 50),
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
