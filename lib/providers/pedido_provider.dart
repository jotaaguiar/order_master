import 'package:flutter/foundation.dart';

class PedidoProvider with ChangeNotifier {
  List<String> _pedidos = []; // Lista de pedidos

  // Getter para acessar os pedidos
  List<String> get pedidos => _pedidos;

  // Calcula o preço total dos pedidos
  double calcularPrecoTotal() {
    double precoTotal = 0.0;

    for (String pedido in _pedidos) {
      final RegExp regex = RegExp(r'Preço: \$([\d\.]+)');
      final match = regex.firstMatch(pedido);

      if (match != null) {
        final precoTexto = match.group(1);
        final preco = double.tryParse(precoTexto ?? '0.0'); // Use '0.0' se precoTexto for nulo
        if (preco != null) {
          precoTotal += preco;
        }
      }
    }

    return precoTotal;
  }

  // Adicione pedidos à lista
  void adicionarPedidos(List<String> pedidos) {
    _pedidos.addAll(pedidos);
    notifyListeners();
  }
}
