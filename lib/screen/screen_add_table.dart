import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScreenAddTable extends StatefulWidget {
  @override
  _ScreenAddTableState createState() => _ScreenAddTableState();
}

class _ScreenAddTableState extends State<ScreenAddTable> {
  int _currentNumberOfTables = 0;

  @override
  void initState() {
    super.initState();
    _fetchNumberOfTables();
  }

  void _fetchNumberOfTables() async {
    // Buscar o valor do contador no Firestore
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('table')
        .doc('contador')
        .get();

    if (snapshot.exists) {
      setState(() {
        _currentNumberOfTables = snapshot.data()?['total_mesas'] ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Configuração Salão', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFA2836E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Número de Mesas: $_currentNumberOfTables',
              style: TextStyle(
                  fontSize: 22, color: Color.fromARGB(255, 105, 87, 74)),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _addTable();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 89, 192, 92),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Adicionar Mesa',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _removeTable();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 230, 97, 88),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Remover Mesa',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _confirmTables();
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFA2836E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Confirmar',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTable() {
    setState(() {
      _currentNumberOfTables++;
    });
  }

  void _removeTable() {
    if (_currentNumberOfTables > 0) {
      setState(() {
        _currentNumberOfTables--;
      });
    }
  }

  void _confirmTables() async {
    if (_currentNumberOfTables > 0) {
      final DocumentReference mesasDoc =
          FirebaseFirestore.instance.collection('table').doc('mesas');

      // Criar um mapa com mesas numeradas
      final Map<String, dynamic> mesas = {};
      for (int i = 1; i <= _currentNumberOfTables; i++) {
        mesas['Mesa $i'] = {'status': 'livre'};
      }

      // Adicionar o mapa de mesas em 'table->mesas'
      await mesasDoc.set(mesas);

      // Atualizar o contador em 'table->contador'
      final DocumentReference contadorDoc =
          FirebaseFirestore.instance.collection('table').doc('contador');
      await contadorDoc.update({
        'total_mesas': _currentNumberOfTables,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mesas confirmadas!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Adicione pelo menos uma mesa antes de confirmar.'),
        ),
      );
    }
  }
}
