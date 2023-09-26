import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'tela_cadastro.dart'; // Importe a tela de cadastro
import 'tela_inicial.dart'; // Importe a tela de inicial

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Master',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.white, // Cor de fundo branca
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Nome de usuário'),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Senha'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Verificar credenciais
                    final enteredUsername = usernameController.text;
                    final enteredPassword = passwordController.text;

                    if (enteredUsername == 'jotaaguiar' &&
                        enteredPassword == 'jotaaguiar09') {
                      setState(() {
                        isAuthenticated = true;
                      });
                      // Navegar para a tela inicial após a autenticação
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TelaInicial(), // Tela inicial
                        ),
                      );
                    } else {
                      // Exibir mensagem de erro
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Erro de autenticação'),
                            content: Text('Sabe a senha não meu nobre?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue), // Cor de fundo azul para o botão
                  ),
                  child: Text('Entrar',
                      style: TextStyle(
                          color: Colors.white)), // Cor do texto branco
                ),
                if (isAuthenticated)
                  Text(
                    'Autenticado!',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                CadastroScreen(), // Tela de cadastro
                          ),
                        );
                      },
                      child: Text('Cadastrar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
