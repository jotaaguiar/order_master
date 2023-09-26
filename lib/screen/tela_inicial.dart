import 'package:flutter/material.dart';
import 'tela_mesa.dart'; // Importe a tela da mesa

class TelaInicial extends StatelessWidget {
  final String nomeGarcom = 'Odair';

  @override
  Widget build(BuildContext context) {
    final mesas = List.generate(10, (index) => 'Mesa ${(index + 1)}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Inicial',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Ação para abrir as configurações
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Garçom: $nomeGarcom',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: mesas.map((mesa) {
                  return Padding(
                    padding: EdgeInsets.all(8.0), // Espaçamento em torno da mesa
                    child: ElevatedButton(
                      onPressed: () {
                        // Navegar para a tela da mesa correspondente
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaMesa(numeroMesa: mesa),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      child: Text(
                        mesa,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}