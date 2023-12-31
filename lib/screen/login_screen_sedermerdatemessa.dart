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
      body: Container(
        color: const Color(0xFFA2836E),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 100.0),
              child: Image.asset(
                'images/LogoOrderMasterFinal.png',
                width: 172,
                height: 172,
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          contentPadding: EdgeInsets.only(bottom: 8),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          contentPadding: EdgeInsets.only(bottom: 8),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 50.0),
                      ElevatedButton(
                        onPressed: () async {
                          final enteredUsername = usernameController.text;
                          final enteredPassword = passwordController.text;

                          if (enteredUsername.isNotEmpty &&
                              enteredPassword.isNotEmpty) {
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
                              Color.fromARGB(255, 0, 0, 0)),
                          minimumSize: MaterialStateProperty.all<Size>(
                            Size(200, 50),
                          ),
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      if (isAuthenticated)
                        Text(
                          'Autenticado!',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      SizedBox(height: 150.0),
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
                              primary: const Color.fromARGB(255, 0, 0, 0),
                            ),
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
