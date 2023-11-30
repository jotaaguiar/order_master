import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:order_master/services/menu_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class TelaCardapio extends StatefulWidget {
  @override
  _TelaCardapioState createState() => _TelaCardapioState();
}

class _TelaCardapioState extends State<TelaCardapio> {
  final nomeController = TextEditingController();
  final precoController = TextEditingController();
  final MenuService _menuService = MenuService();

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
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            TextFormField(
              controller: precoController,
              decoration: InputDecoration(
                labelText: 'Preço',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[600],
                onPrimary: Colors.white,
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
              child: StreamBuilder<QuerySnapshot>(
                stream: _menuService.getMenuStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  var items = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index].data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(item['nome']),
                        subtitle: Text('Preço: ${item['preco']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            print(items[index].id);
                            removerItem(items[index].id);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void adicionarItem() async {
    final nome = nomeController.text;
    final preco = double.tryParse(precoController.text) ?? 0.0;

    if (nome.isNotEmpty && preco > 0) {
      await _menuService.adicionarItem(nome, preco);

      nomeController.clear();
      precoController.clear();
    }
  }

  void removerItem(String itemId) async {
    await _menuService.removerItem(itemId);
  }
}