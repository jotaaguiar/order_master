import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:order_master/providers/pedido_provider.dart';

class TelaVisualizar extends StatelessWidget {
  final String numeroMesa;

  TelaVisualizar({required this.numeroMesa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualizar Pedidos - $numeroMesa',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.blue,
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.all(16.0),
              child: Text(
                'Pedidos:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<PedidoProvider>(
                  builder: (context, pedidoProvider, child) {
                    final pedidos = pedidoProvider.pedidos;
                    final precoTotal = pedidoProvider.calcularPrecoTotal();
                    return Column(
                      children: pedidos.map((pedido) {
                        return Container(
                          color: Colors.white,
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
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              color: Colors.blue,
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.all(16.0),
              child: Consumer<PedidoProvider>(
                builder: (context, pedidoProvider, child) {
                  final precoTotal = pedidoProvider.calcularPrecoTotal();
                  return Text(
                    'Preço Total: R\$ ${precoTotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
