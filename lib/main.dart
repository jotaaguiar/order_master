import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:order_master/screen/tela_first.dart';
import 'providers/pedido_provider.dart'; // Importe a classe PedidoProvider
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PedidoProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MesaProvider(),
        ),
      ],
      child: MaterialApp(
        home: TelaFirst(),
      ),
    ),
  );
}
