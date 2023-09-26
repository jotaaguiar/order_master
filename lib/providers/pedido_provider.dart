import 'package:flutter/foundation.dart';

class PedidoProvider with ChangeNotifier {
  Map<String, List<String>> _pedidosPorMesa = {}; // Mapa de pedidos por mesa

  // Getter para acessar os pedidos de uma mesa
  List<String> getPedidosPorMesa(String numeroMesa) {
    return _pedidosPorMesa[numeroMesa] ?? [];
  }

  // Calcula o preço total dos pedidos de uma mesa
  double calcularPrecoTotal(String numeroMesa) {
    double precoTotal = 0.0;

    final pedidos = _pedidosPorMesa[numeroMesa] ?? [];

    for (String pedido in pedidos) {
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

  // Adicionar pedidos a uma mesa específica
  void adicionarPedidos(String numeroMesa, List<String> pedidos) {
    if (_pedidosPorMesa.containsKey(numeroMesa)) {
      _pedidosPorMesa[numeroMesa]!.addAll(pedidos);
    } else {
      _pedidosPorMesa[numeroMesa] = List.from(pedidos);
    }
    notifyListeners();
  }
}
