import 'package:flutter/material.dart';

class TelaVisualizar extends StatelessWidget {
  final List<String> pedidos;

  TelaVisualizar({required this.pedidos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualizar Pedidos'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Pedidos:',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: pedidos.map((pedido) {
                  return PedidoBox(pedido: pedido);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PedidoBox extends StatelessWidget {
  final String pedido;

  PedidoBox({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pedido,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
