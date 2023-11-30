import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaVisualizar extends StatelessWidget {
  final String numeroMesa;

  TelaVisualizar({required this.numeroMesa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Visualizar Pedidos - $numeroMesa',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[800],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(10.0),
              ),
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
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: getPedidosStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    var pedidos = snapshot.data!.docs;

                    return Column(
                      children: pedidos.map((pedido) {
                        var pedidoData = pedido.data() as Map<String, dynamic>;
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 194, 194, 194),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            "${pedidoData['nome']} - Preço: R\$${pedidoData['preco'].toStringAsFixed(2)} - Observação: ${pedidoData['observacao']}",
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
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.all(5.0),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: getPedidosStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  var pedidos = snapshot.data!.docs;

                  final precoTotal = pedidos.fold<double>(
                    0,
                    (total, pedido) => total + (pedido['preco'] as double),
                  );

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

  Stream<QuerySnapshot<Map<String, dynamic>>> getPedidosStream() {
    return FirebaseFirestore.instance
        .collection('orders')
        .doc(numeroMesa)
        .collection('pedidos')
        .snapshots();
  }
}