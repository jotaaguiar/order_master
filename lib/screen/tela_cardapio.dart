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
        title: Text('Configurações no Cardápio', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFA2836E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Text('Adicionar Itens no Cardápio', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 20.0),
            TextFormField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: 'Nome do Item',
                labelStyle: TextStyle(color: const Color.fromARGB(255, 107, 106, 106)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                // Ajuste do espaçamento interno para o campo de texto do nome do item
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              ),
              style: TextStyle(fontSize: 16.0),
            ),
            TextFormField(
              controller: precoController,
              decoration: InputDecoration(
                labelText: 'Preço',
                labelStyle: TextStyle(color: const Color.fromARGB(255, 107, 106, 106)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                // Ajuste do espaçamento interno para o campo de texto do preço
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 5.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFA2836E),
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                adicionarItem();
              },
              child: Text('Adicionar Item', style: TextStyle(fontSize: 16.0)),
            ),
            SizedBox(height: 20.0),
            Text('Itens no Cardápio:', style: TextStyle(fontSize: 18.0)),
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
      try {
        await _menuService.adicionarItem(nome, preco);
        nomeController.clear();
        precoController.clear();
      } catch (e) {
        print("Error adding item: $e");
      }
    }
  }

  void removerItem(String itemId) async {
    await _menuService.removerItem(itemId);
  }
}
