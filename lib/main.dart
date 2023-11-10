 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:order_master/screen/tela_first.dart';
import 'providers/pedido_provider.dart'; // Importe a classe PedidoProvider


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PedidoProvider(),
        ),
      ],
      child: MaterialApp(
        home: TelaFirst(),
      ),
    ),
  );
}