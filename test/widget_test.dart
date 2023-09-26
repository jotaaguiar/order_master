import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:order_master/screen/login_screen.dart'; // Importe a tela de login a partir da nova localização.// Importe o seu arquivo principal (ou o arquivo onde você configurou a tela de login).

void main() {
  testWidgets('Teste de tela de login', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Aguarde a renderização da tela de login.
    await tester.pump();

    // Verifique se alguns widgets específicos estão presentes na tela de login.
    expect(find.text('Nome de usuário'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
