// TelaAlterar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:order_master/providers/pedido_provider.dart';

class TelaAlterar extends StatelessWidget {
  final String numeroMesa;

  TelaAlterar({required this.numeroMesa});

  @override
  Widget build(BuildContext context) {
    final pedidoProvider = Provider.of<PedidoProvider>(context);
    final pedidos = pedidoProvider.pedidos;

    return Scaffold(
      appBar: AppBar(
        title: Text('Alterar Pedidos - Mesa $numeroMesa'),
        backgroundColor: Colors.grey[800],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: pedidos.length,
        itemBuilder: (context, index) {
          final pedido = pedidos[index];

          return PedidoItem(
            pedido: pedido,
            onRemover: () {
              pedidoProvider.removerPedido(index); // Remove o pedido específico
            },
          );
        },
      ),
    );
  }
}

class PedidoItem extends StatelessWidget {
  final String pedido;
  final VoidCallback? onRemover;

  PedidoItem({required this.pedido, this.onRemover});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(pedido),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            onRemover?.call(); // Chama a função de remoção quando o ícone de exclusão é pressionado
          },
        ),
      ),
    );
  }
}
