import 'package:flutter/material.dart';
import 'tela_mesa.dart'; 
import 'tela_config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TelaInicial extends StatelessWidget {
  final String username;

  TelaInicial({required this.username});

  @override
  Widget build(BuildContext context) {
    final mesas = List.generate(10, (index) => 'Mesa ${(index + 1)}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Inicial', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[800],
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false, // Remove a seta de volta
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaConfig()),
              );
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
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Garçom: $username',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: mesas.map((mesa) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaMesa(numeroMesa: mesa),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey[600],
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
