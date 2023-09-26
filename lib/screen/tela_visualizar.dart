import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:order_master/providers/pedido_provider.dart';

class TelaVisualizar extends StatelessWidget {
  final String numeroMesa; // Adicione o número da mesa como um atributo

  TelaVisualizar({required this.numeroMesa}); // Construtor

  @override
  Widget build(BuildContext context) {
    final pedidoProvider = Provider.of<PedidoProvider>(context);
    final pedidos = pedidoProvider.getPedidosPorMesa(numeroMesa); // Obtenha os pedidos com base no número da mesa
    final precoTotal = pedidoProvider.calcularPrecoTotal(numeroMesa); // Calcule o preço total com base no número da mesa

    return Scaffold(
      appBar: AppBar(
        title: Text('Visualizar Pedidos - Mesa $numeroMesa'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.blue, // Cor de fundo azul para o título
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Pedidos:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Cor do texto branco para o título
                ),
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: pedidos.map((pedido) {
                return Container(
                  color: Colors.white, // Cor de fundo branca para cada item de pedido
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    pedido,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Container(
              color: Colors.blue, // Cor de fundo azul para o total
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Preço Total: R\$ ${precoTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Cor do texto branco para o total
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
