import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_master/providers/pedido_provider.dart';
import 'package:provider/provider.dart';

class TelaInserir extends StatefulWidget {
  final String numeroMesa;

  TelaInserir({required this.numeroMesa});

  @override
  _TelaInserirState createState() => _TelaInserirState();
}

class _TelaInserirState extends State<TelaInserir> {
  late List<Map<String, dynamic>> opcoes;
  late Map<String, String?> observacoes;
  late Map<String, int> quantidades;

  late CollectionReference<Map<String, dynamic>> orderCollection;
  late Stream<QuerySnapshot<Map<String, dynamic>>> menuStream;

  @override
  void initState() {
    super.initState();
    observacoes = {};
    quantidades = {};
    opcoes = [];
    orderCollection = FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.numeroMesa)
        .collection('pedidos');
    menuStream = getMenuStream();

    menuStream.listen((querySnapshot) {
      setState(() {
        opcoes = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get newMethod => menuStream;

  Stream<QuerySnapshot<Map<String, dynamic>>> getMenuStream() {
    return FirebaseFirestore.instance.collection('menu').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final pedidoProvider = Provider.of<PedidoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Inserir Pedido - ${widget.numeroMesa} ', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFA2836E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Padding(
              //padding: EdgeInsets.all(16.0),
              //child: Text(
                //'Selecione uma opção:',
                //style: TextStyle(fontSize: 18),
              //),
            //),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: opcoes.map((opcao) {
                  final nome = opcao['nome'];
                  final preco = opcao['preco'];

                  final isSelected = observacoes.containsKey(nome);

                  return OpcaoBox(
                    nome: nome,
                    preco: preco,
                    observacao: observacoes[nome],
                    quantidade: quantidades[nome] ?? 1,
                    isSelected: isSelected,
                    onChangedObservacao: (value) {
                      setState(() {
                        observacoes[nome] = value;
                      });
                    },
                    onChangedQuantidade: (value) {
                      setState(() {
                        quantidades[nome] = value;
                      });
                    },
                    onToggleSelection: () {
                      setState(() {
                        if (isSelected) {
                          observacoes.remove(nome);
                        } else {
                          observacoes[nome] = '';
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[600], // Cor de fundo cinza
                onPrimary: Colors.white, // Cor do texto branco
              ),
              onPressed: () {
                adicionarPedidos(context, pedidoProvider);
              },
              child: Text('Concluir Pedido'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> adicionarPedidos(
      BuildContext context, PedidoProvider pedidoProvider) async {
    final List<Map<String, dynamic>> pedidosComQuantidade = [];

    for (final opcao in observacoes.keys) {
      final nome = opcao;
      final preco =
          opcoes.firstWhere((opcao) => opcao['nome'] == nome)['preco'];
      final observacao = observacoes[nome] ?? "";
      final quantidade = quantidades[nome] ?? 1;

      for (int i = 0; i < quantidade; i++) {
        // Adicione o pedido à subcoleção de pedidos no documento da mesa
        await orderCollection.add({
          'nome': nome,
          'preco': preco,
          'observacao': observacao,
        });

        // Adicione o preço à lista de preços
        pedidoProvider.precos.add(preco);
      }
    }

    setState(() {
      observacoes.clear();
      quantidades.clear();
    });
    await FirebaseFirestore.instance.collection('table').doc('mesas').update({
      widget.numeroMesa: {'status': 'ocupado'}
    });
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pedidos adicionados com sucesso!'),
      ),
    );
  }
}

class OpcaoBox extends StatelessWidget {
  final String? nome;
  final double? preco;
  final String? observacao;
  final int quantidade;
  final bool isSelected;
  final ValueChanged<String?>? onChangedObservacao;
  final ValueChanged<int>? onChangedQuantidade;
  final VoidCallback? onToggleSelection;

  OpcaoBox({
    required this.nome,
    required this.preco,
    this.observacao,
    required this.quantidade,
    required this.isSelected,
    this.onChangedObservacao,
    this.onChangedQuantidade,
    this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 5 : 3,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  nome!,
                  style: TextStyle(fontSize: 16),
                ),
                Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    onToggleSelection?.call();
                  },
                ),
              ],
            ),
            Text(
              'Preço: R\$${preco!.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text('Quantidade:'),
                SizedBox(width: 8),
                DropdownButton<int>(
                  value: quantidade,
                  onChanged: (value) {
                    onChangedQuantidade?.call(value!);
                  },
                  items: List.generate(10, (index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text((index + 1).toString()),
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 8),
            TextFormField(
              initialValue: observacao,
              onChanged: onChangedObservacao,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Adicionar observação (opcional)',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
