// provider.dart
import 'package:flutter/material.dart';

class PedidoProvider extends ChangeNotifier {
  List<String> pedidos = [];
  List<double> precos = []; // Adicione esta lista

  void adicionarPedidos(List<String> pedidos) {
    this.pedidos.addAll(pedidos);
    notifyListeners();
  }

  void removerPedido(int index) {
    pedidos.removeAt(index);
    notifyListeners();
  }


  // Novo método para calcular o preço total diretamente
  double calcularPrecoTotal() {
    double total = 0.0;
    for (var preco in precos) {
      total += preco;
    }
    return total;
  }
}