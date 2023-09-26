import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:order_master/providers/pedido_provider.dart';

class TelaInserir extends StatefulWidget {
  final String numeroMesa;

  TelaInserir({required this.numeroMesa});

  @override
  _TelaInserirState createState() => _TelaInserirState();
}

class _TelaInserirState extends State<TelaInserir> {
  List<Map<String, dynamic>> opcoes = [
    {'nome': 'Refrigerante Lata', 'preco': 5.0},
    {'nome': 'Porção de Arroz', 'preco': 15.0},
    {'nome': 'Salada', 'preco': 10.0},
    {'nome': 'Farofa', 'preco': 8.0},
    {'nome': 'Brahma Latão', 'preco': 7.0},
    {'nome': 'Heineken 600ml', 'preco': 12.0},
    {'nome': 'Budweiser long neck', 'preco': 10.0},
    {'nome': 'Cerveja pra curar Traição', 'preco': 20.0},
  ];

  Map<String, String?> observacoes = {}; // Mapeia as observações para cada opção

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.numeroMesa} - Inserir Pedido'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Selecione uma opção:',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: opcoes.map((opcao) {
                  final nome = opcao['nome'];
                  final preco = opcao['preco'];
                  return OpcaoBox(
                    nome: nome,
                    preco: preco,
                    observacao: observacoes[nome],
                    onChangedObservacao: (value) {
                      setState(() {
                        observacoes[nome] = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                adicionarPedidos(context);
              },
              child: Text('Adicionar Pedidos'),
            ),
          ],
        ),
      ),
    );
  }

  void adicionarPedidos(BuildContext context) {
    final pedidoProvider = Provider.of<PedidoProvider>(context, listen: false);

    final pedidos = opcoes.map((opcao) {
      final nome = opcao['nome'];
      final preco = opcao['preco'];
      final observacao = observacoes[nome] ?? "";
      return "$nome - Preço: \$${preco!.toStringAsFixed(2)} - Observação: $observacao";
    }).toList();

    // Adicione os pedidos à mesa correta
    pedidoProvider.adicionarPedidos(widget.numeroMesa, pedidos);

    // Limpe a lista de observações após a adição
    setState(() {
      observacoes.clear();
    });

    // Exiba uma mensagem de sucesso
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
  final ValueChanged<String?>? onChangedObservacao;

  OpcaoBox({
    required this.nome,
    required this.preco,
    this.observacao,
    this.onChangedObservacao,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nome!,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Preço: \$${preco!.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 14),
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
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Adicione a lógica de adição aqui, se desejar
                mostrarMensagemSucesso(context);
              },
              child: Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }

  void mostrarMensagemSucesso(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Adicionado com sucesso: $nome'),
      ),
    );
  }
}