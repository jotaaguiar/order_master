import 'package:flutter/material.dart';

class TelaInserir extends StatefulWidget {
  final String numeroMesa;

  TelaInserir({required this.numeroMesa});

  @override
  _TelaInserirState createState() => _TelaInserirState();
}

class _TelaInserirState extends State<TelaInserir> {
  List<String> opcoes = [
    'Refrigerante Lata',
    'Porção de Arroz',
    'Salada',
    'Farofa',
    'Brahama Latão',
    'Heineken 600ml',
    'Budweiser long neck',
    'Cerveja pra curar Traição',
    // Adicione mais opções conforme necessário
  ];

  Map<String, String> observacoes = {}; // Mapeia as observações para cada opção

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
                  return OpcaoBox(
                    opcao: opcao,
                    observacao: observacoes[opcao],
                    onChangedObservacao: (value) {
                      setState(() {
                        observacoes[opcao] = value!;
                      });
                    },
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

class OpcaoBox extends StatelessWidget {
  final String opcao;
  final String? observacao;
  final ValueChanged<String?>? onChangedObservacao;

  OpcaoBox({
    required this.opcao,
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
              opcao,
              style: TextStyle(fontSize: 16),
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
        content: Text('Adicionado com sucesso para $opcao'),
      ),
    );
  }
}
