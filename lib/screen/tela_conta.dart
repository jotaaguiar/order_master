import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:order_master/providers/pedido_provider.dart';

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

  void calcularTotalDaConta() {
    final pedidoProvider = Provider.of<PedidoProvider>(context, listen: false);
    totalDaConta = pedidoProvider.precos.fold(0, (a, b) => a + b);
    atualizarValorPorPessoa();
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
      // Verifica se o total ficou negativo e ajusta
      if (totalDaConta < 0) {
        totalDaConta = 0;
      }

      atualizarValorPorPessoa();
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

  void removerTodosOsPedidos() {
    final pedidoProvider = Provider.of<PedidoProvider>(context, listen: false);
    pedidoProvider.removerTodosPedidos();
    calcularTotalDaConta();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conta'),
        backgroundColor: Colors.grey[800],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
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
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Pedidos:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<PedidoProvider>(
                  builder: (context, pedidoProvider, child) {
                    final pedidos = pedidoProvider.pedidos;
                    return Column(
                      children: pedidos.map((pedido) {
                        return Container(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            pedido,
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
                        MaterialStateProperty.all(Colors.grey[600]),
                  ),
                  onPressed: adicionarPessoa,
                  child: Text('Adicionar Pessoa'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.grey[600]),
                  ),
                  onPressed: removerPessoa,
                  child: Text('Remover Pessoa'),
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
              style: TextStyle(fontSize: 18),
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
                backgroundColor: MaterialStateProperty.all(Colors.grey[600]),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String nomePessoa = '';
                    double valorPago = 0.0;

                    return AlertDialog(
                      title: Text('Adicionar Pessoa que Pagou'),
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
              child: Text('Adicionar Pessoa que Pagou'),
            ),
            Divider(),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey[600]),
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
              child: Text('Encerrar conta'),
            ),
          ],
        ),
      ),
    );
  }
}
