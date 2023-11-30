import 'package:flutter/material.dart';
import 'tela_mesa.dart';
import 'tela_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaInicial extends StatelessWidget {
  final String username;

  TelaInicial({required this.username});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('table').doc('mesas').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        Map<String, dynamic>? mesasData = snapshot.data?.data();
        if (mesasData == null) {
          return CircularProgressIndicator();
        }

        List<MapEntry<String, dynamic>> sortedMesas = mesasData.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));

        return Scaffold(
          appBar: AppBar(
            title: Text('Salão', style: TextStyle(color: Colors.white)),
            backgroundColor: Color(0xFFA2836E),
            iconTheme: IconThemeData(color: Colors.white),
            automaticallyImplyLeading: false,
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
            padding: EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: sortedMesas.map((entry) {
                      String mesaNumero = entry.key;
                      String mesaStatus = entry.value['status'] ?? 'livre';

                      Color corBotao = mesaStatus == 'livre' ? Colors.green : Colors.red;

                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TelaMesa(numeroMesa: mesaNumero),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: corBotao,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          child: Text(
                            mesaNumero,
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
                SizedBox(height: 2.0),
                Center(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleIndicator(color: Colors.green),
                            SizedBox(width: 1.0),
                            Text(
                              'Livre',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(width: 20.0),
                            CircleIndicator(color: Colors.red),
                            SizedBox(width: 1.0),
                            Text(
                              'Ocupado',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          margin: EdgeInsets.only(left: 0.0), // Margem à esquerda
                          child: Text(
                            'Atendente: $username',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CircleIndicator extends StatelessWidget {
  final Color color;

  CircleIndicator({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      height: 20.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
