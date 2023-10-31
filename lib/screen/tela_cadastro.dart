import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'login_screen.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController confirmEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late Database database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final dbPath =
        path.join(await getDatabasesPath(), 'cadastro_bancodedados.db');
    database = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE cadastro(id INTEGER PRIMARY KEY, username TEXT, email TEXT, password TEXT)',
      );
    });
  }

  Future<void> saveCadastro(
      String username, String email, String password) async {
    if (database == null) {
      print("O banco de dados não foi inicializado corretamente.");
      return;
    }

    await database.insert(
      'cadastro',
      {
        'username': username,
        'email': email,
        'password': password,
      },
    );

    showSuccessDialog(context);

    print('Nome de Usuário: $username');
    print('Email: $email');
    print('Senha: $password');
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cadastro Realizado com Sucesso'),
          content: Text('Seja Bem vindo ao Order Master Group'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro de Usuário',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[800],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                    labelText: 'Nome de usuário',
                    labelStyle: TextStyle(color: Colors.grey), // Define a cor cinza do rótulo
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey), // Define a borda cinza enquanto está focado
                    ),
                  ),
              
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                    labelText: 'E-mail',
                    labelStyle: TextStyle(color: Colors.grey), // Define a cor cinza do rótulo
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey), // Define a borda cinza enquanto está focado
                    ),
                  ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: confirmEmailController,
             decoration: InputDecoration(
                    labelText: 'Confirmação de e-mail',
                    labelStyle: TextStyle(color: Colors.grey), // Define a cor cinza do rótulo
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey), // Define a borda cinza enquanto está focado
                    ),
                  ),
              keyboardType: TextInputType.emailAddress,
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
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.grey[800]), // Cor azul
              ),
              onPressed: () async {
                final email = emailController.text;
                final confirmEmail = confirmEmailController.text;
                final password = passwordController.text;
                final username = usernameController.text;

                if (email == confirmEmail) {
                  await saveCadastro(username, email, password);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Erro de cadastro'),
                        content: Text(
                            'Verifique os campos de email. Por favor, tente novamente.'),
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
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
