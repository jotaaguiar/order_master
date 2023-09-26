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
    {'nome': 'Refrigerante Lata', 'preco': 15.0},
    {'nome': 'Porção de Arroz', 'preco': 15.0},
    {'nome': 'Salada', 'preco': 10.0},
    {'nome': 'Farofa', 'preco': 8.0},
    {'nome': 'Brahma Latão', 'preco': 7.0},
    {'nome': 'Heineken 600ml', 'preco': 12.0},
    {'nome': 'Budweiser long neck', 'preco': 10.0},
    {'nome': 'Cerveja pra curar Traição', 'preco': 20.0},
  ];

  List<Map<String, dynamic>> itensSelecionados = [];

  Map<String, String?> observacoes = {};
  Map<String, int> quantidades = {};

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
                  final isSelected = itensSelecionados.contains(opcao);

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
                          itensSelecionados.remove(opcao);
                        } else {
                          itensSelecionados.add(opcao);
                        }
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

    final List<Map<String, dynamic>> pedidosComQuantidade = [];

    for (final opcao in itensSelecionados) {
      final nome = opcao['nome'];
      final preco = opcao['preco'];
      final observacao = observacoes[nome] ?? "";
      final quantidade = quantidades[nome] ?? 1;

      for (int i = 0; i < quantidade; i++) {
        pedidosComQuantidade.add({
          'nome': nome,
          'preco': preco,
          'observacao': observacao,
        });

        // Adicione o preço à lista de preços
        pedidoProvider.precos.add(preco);
      }
    }

    final pedidos = pedidosComQuantidade.map((pedido) {
      final nome = pedido['nome'];
      final preco = pedido['preco'];
      final observacao = pedido['observacao'];

      return "$nome - Preço: R\$${preco.toStringAsFixed(2)} - Observação: $observacao";
    }).toList();

    pedidoProvider.adicionarPedidos(pedidos);

    setState(() {
      observacoes.clear();
      quantidades.clear();
      itensSelecionados.clear();
    });

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
