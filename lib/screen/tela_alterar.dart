import 'package:flutter/material.dart';
import 'package:order_master/services/menu_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaAlterar extends StatelessWidget {
  final String numeroMesa;

  TelaAlterar({required this.numeroMesa});

  @override
  Widget build(BuildContext context) {
    final orderService = MenuService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Alterar Pedidos - $numeroMesa'),
        backgroundColor: Colors.grey[800],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: getPedidosStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var pedidos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              var pedido = pedidos[index].data() as Map<String, dynamic>;
              var pedidoId = pedidos[index].id;

              return PedidoItem(
                pedido: pedido,
                onRemover: () {
                  removerPedido(context, pedidoId);
                },
              );
            },
          );
        },
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPedidosStream() {
    return FirebaseFirestore.instance
        .collection('orders')
        .doc(numeroMesa)
        .collection('pedidos')
        .snapshots();
  }

  void removerPedido(BuildContext context, String pedidoId) {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(numeroMesa)
        .collection('pedidos')
        .doc(pedidoId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pedido removido com sucesso!'),
      ),
    );
  }
}

class PedidoItem extends StatelessWidget {
  final Map<String, dynamic> pedido;
  final VoidCallback? onRemover;

  PedidoItem({required this.pedido, this.onRemover});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text('${pedido['nome']}'),
        subtitle: Text('Preço: ${pedido['preco']}'),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            onRemover?.call();
          },
        ),
      ),
    );
  }
}