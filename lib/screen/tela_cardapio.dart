import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class TelaCardapio extends StatefulWidget {
  @override
  _TelaCardapioState createState() => _TelaCardapioState();
}

class _TelaCardapioState extends State<TelaCardapio> {
  late Database database;
  final nomeController = TextEditingController();
  final precoController = TextEditingController();
  List<Map<String, dynamic>> itens = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final databasePath = path.join(dbPath, 'cardapio.db');

    database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('CREATE TABLE itens (id INTEGER PRIMARY KEY, nome TEXT, preco REAL)');
      },
    );

    _carregarItens();
  }

  Future<void> _carregarItens() async {
    final resultados = await database.query('itens');
    setState(() {
      itens = resultados;
    });
  }

  Future<void> adicionarItem() async {
    final nome = nomeController.text;
    final preco = double.tryParse(precoController.text) ?? 0.0;

    if (nome.isNotEmpty && preco > 0) {
      await database.insert('itens', {'nome': nome, 'preco': preco});
      nomeController.clear();
      precoController.clear();
      mostrarSnackBar('Item adicionado com sucesso');
      _carregarItens();
    }
  }

  Future<void> removerItem(int id) async {
    await database.delete('itens', where: 'id = ?', whereArgs: [id]);
    mostrarSnackBar('Item removido com sucesso');
    _carregarItens();
  }

  void mostrarSnackBar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações no Cardápio'),
        backgroundColor: Colors.grey[800],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Adicionar Itens no Cardápio',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: nomeController,
              decoration: InputDecoration(
                    labelText: 'Nome do Item',
                    labelStyle: TextStyle(color: Colors.grey), // Define a cor cinza do rótulo
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey), // Define a borda cinza enquanto está focado
                    ),
                  ),
            ),
            TextFormField(
              controller: precoController,
              decoration: InputDecoration(
                    labelText: 'Preço',
                    labelStyle: TextStyle(color: Colors.grey), // Define a cor cinza do rótulo
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey), // Define a borda cinza enquanto está focado
                    ),
                  ),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[600], // Cor de fundo cinza
                onPrimary: Colors.white, // Cor do texto branco
              ),
              onPressed: () {
                adicionarItem();
              },
              child: Text('Adicionar Item'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Itens no Cardápio:',
              style: TextStyle(fontSize: 18.0),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: itens.length,
                itemBuilder: (context, index) {
                  final item = itens[index];
                  return ListTile(
                    title: Text(item['nome']),
                    subtitle: Text('Preço: ${item['preco']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        removerItem(item['id']);
                      },
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
