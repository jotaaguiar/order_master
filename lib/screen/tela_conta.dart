import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaConta extends StatefulWidget {
  final String numeroMesa;

  TelaConta({required this.numeroMesa});

  @override
  _TelaContaState createState() => _TelaContaState();
}

class _TelaContaState extends State<TelaConta> {
  int numeroDePessoas = 1;
  double totalDaConta = 0.0;
  double valorPorPessoa = 0.0;
  List<String> pessoasPagaram = [];
  Map<String, double> valorPagoPorPessoa = {};

  @override
  void initState() {
    super.initState();
    calcularTotalDaConta();
  }

  Future<void> calcularTotalDaConta() async {
    var pedidos = await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.numeroMesa)
        .collection('pedidos')
        .get();

    if (mounted) {
      setState(() {
        totalDaConta = pedidos.docs.fold<double>(
          0,
          (total, pedido) => total + (pedido['preco'] as double? ?? 0),
        );

        // Atualize o valor por pessoa
        atualizarValorPorPessoa();
      });
    }
  }

  void atualizarValorPorPessoa() {
    if (numeroDePessoas > 0) {
      valorPorPessoa = totalDaConta / numeroDePessoas;
    } else {
      valorPorPessoa = 0;
    }
  }

  void dividirConta() {
    atualizarValorPorPessoa();
  }

  void adicionarPessoa() {
    setState(() {
      numeroDePessoas++;
      dividirConta();
    });
  }

  void removerPessoa() {
    if (numeroDePessoas > 1) {
      setState(() {
        numeroDePessoas--;
        dividirConta();
      });
    }
  }

  void adicionarPessoaQuePagou(String pessoa, double valorPago) {
    setState(() {
      pessoasPagaram.add(pessoa);
      valorPagoPorPessoa[pessoa] = valorPago;

      // Reduz o valor total da conta pelo valor que a pessoa pagou
      totalDaConta -= valorPago;

      // Atualize o valor por pessoa
      atualizarValorPorPessoa();
      removerPessoa();
    });
  }

  void editarPessoaQuePagou(String nomePessoa, double valorPago) {
    setState(() {
      // Remove a pessoa da lista
      pessoasPagaram.remove(nomePessoa);
      // Remove o valor pago dessa pessoa do total da conta
      totalDaConta += valorPago;
    });
  }

  void removerTodosOsPedidos() async {
    var pedidos = await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.numeroMesa)
        .collection('pedidos')
        .get();

    await FirebaseFirestore.instance.collection('table').doc('mesas').update({
      widget.numeroMesa: {'status': 'livre'}
    });

    for (var pedido in pedidos.docs) {
      await pedido.reference.delete();
    }

    await calcularTotalDaConta(); // Aguarde a conclusão antes de continuar

    // Redesenha o widget após a atualização
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conta', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFA2836E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total da Conta: R\$${totalDaConta.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Pedidos:',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: getPedidosStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }

                      var pedidos = snapshot.data!.docs;

                      return Column(
                        children: pedidos.map((pedido) {
                          var pedidoData =
                              pedido.data() as Map<String, dynamic>;
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 4.0),
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "${pedidoData['nome']} - Preço: R\$${pedidoData['preco'].toStringAsFixed(2)} - Observação: ${pedidoData['observacao']}",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
              Divider(),
              Text(
                'Número de Pessoas: $numeroDePessoas',
                style: TextStyle(fontSize: 18),
              ),
              Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFFA2836E)),
                    ),
                    onPressed: adicionarPessoa,
                    child: Text('Adicionar Pessoa',style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFFA2836E)),
                    ),
                    onPressed: removerPessoa,
                    child: Text('Remover Pessoa',style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              Divider(),
              Text(
                'Valor por Pessoa: R\$${valorPorPessoa.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Pessoas que já pagaram:',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: pessoasPagaram.map((pessoa) {
                  double valorPago = valorPagoPorPessoa[pessoa] ?? 0.0;
                  return ListTile(
                    title: Text(pessoa, style: TextStyle(fontSize: 16)),
                    subtitle: Text(
                      'Valor pago: R\$${valorPago.toStringAsFixed(2)}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        editarPessoaQuePagou(pessoa, valorPago);
                      },
                    ),
                  );
                }).toList(),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFA2836E)),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String nomePessoa = '';
                      double valorPago = 0.0;

                      return AlertDialog(
                        title: Text('Adicionar Pessoa que Pagou',style: TextStyle(color: Colors.black)),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Nome da Pessoa',
                                labelStyle: TextStyle(color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              onChanged: (value) {
                                nomePessoa = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Valor Pago',
                                labelStyle: TextStyle(color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                valorPago = double.tryParse(value) ?? 0.0;
                              },
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancelar'),
                            style: TextButton.styleFrom(
                              primary: Colors.grey[600],
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Adicionar'),
                            style: TextButton.styleFrom(
                              primary: Colors.grey[600],
                            ),
                            onPressed: () {
                              adicionarPessoaQuePagou(nomePessoa, valorPago);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Adicionar Pessoa que Pagou',style: TextStyle(color: Colors.white)),
              ),
              Divider(),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFA2836E)),
                ),
                onPressed: () {
                  // Remover todos os pedidos
                  removerTodosOsPedidos();

                  // Mostrar uma mensagem com um diálogo
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Conta Encerrada'),
                        content: Text('Obrigado por usar o OrderMaster.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Voltar para a tela inicial
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Encerrar conta',style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPedidosStream() {
    return FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.numeroMesa)
        .collection('pedidos')
        .snapshots();
  }
}
