import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tela_cadastro.dart';
import 'tela_inicial.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isAuthenticated = false;
  Database? database;

  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    database = await openDatabase(
      join(dbPath, 'cadastro_bancodedados.db'),
      version: 1,
    );

    // Adicione a seguinte verificação para garantir que o banco de dados não está fechado
    if (database?.isOpen != true) {
      database = await openDatabase(
        join(dbPath, 'cadastro_bancodedados.db'),
        version: 1,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<bool> authenticateUser(String username, String password) async {
    if (database == null) {
      print("O banco de dados não foi inicializado corretamente.");
      return false;
    }

    final List<Map<String, dynamic>> result = await database!.query(
      'cadastro',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Master',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[800],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.grey), // Define a cor cinza do rótulo
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey), // Define a borda cinza enquanto está focado
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    labelStyle: TextStyle(color: Colors.grey), // Define a cor cinza do rótulo
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey), // Define a borda cinza enquanto está focado
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    final enteredUsername = usernameController.text;
                    final enteredPassword = passwordController.text;

                    final isAuthenticated = await authenticateUser(
                      enteredUsername,
                      enteredPassword,
                    );

                    if (isAuthenticated) {
                      setState(() {
                        this.isAuthenticated = true;
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TelaInicial(username: enteredUsername),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Erro de autenticação'),
                            content: Text(
                                'Credenciais inválidas. Por favor, tente novamente.'),
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
                        Color.fromARGB(255, 61, 60, 60)),
                  ),
                  child: Text('Entrar', style: TextStyle(color: Colors.white)),
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
                            builder: (context) => CadastroScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.grey[800], // Define a cor cinza
                      ),
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
