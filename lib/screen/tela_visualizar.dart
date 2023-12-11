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
        backgroundColor: Color(0xFFA2836E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pedidos:',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20), // Ajustei a altura para 20
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: getPedidosStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                var pedidos = snapshot.data!.docs;

                return Container(
                  width: double.infinity, // Define a largura como a maior possível
                  margin: EdgeInsets.symmetric(horizontal: 3.0), // Margem horizontal de 3
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: pedidos.map((pedido) {
                      var pedidoData = pedido.data() as Map<String, dynamic>;
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 240, 218, 204),
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
                  ),
                );
              },
            ),
            SizedBox(height: 20), // Ajustei a altura para 20
            Container(
              width: double.infinity, // Define a largura como a maior possível
              margin: EdgeInsets.symmetric(horizontal: 3.0), // Margem horizontal de 3
              decoration: BoxDecoration(
                color: Color(0xFFA2836E),
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(16.0),
              //margin: EdgeInsets.symmetric(vertical: 5.0), // Ajustei a margem vertical para 5
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
