import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app',
      initialRoute: "/",
      routes: {
        '/': (context) => LoginPage(),
        '/importarProdutos': (context) => ImportarProdutosPage(),
        /* '/login': (context) => LoginPage(),
        '/notasAluno': (context) => NotasAlunoPage(), */
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();

  void _enviar() async {
    String email = _email.text;
    String senha = _senha.text;

    if (email.isNotEmpty && senha.isNotEmpty) {
      Navigator.pushReplacementNamed(
          context as BuildContext, '/importarProdutos');
    } else {
      Navigator.pushReplacementNamed(context as BuildContext, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 200),
            SizedBox(
                width: 300,
                child: TextField(
                  controller: _email,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      hintText: 'Login',
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder()),
                )),
            const SizedBox(height: 16.0),
            const SizedBox(height: 16.0),
            SizedBox(
                width: 300,
                child: TextField(
                  controller: _senha,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      hintText: 'Senha',
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder()),
                )),
            const SizedBox(height: 100.0),
            SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _enviar,
                      child: const Text('Enviar'),
                    ),
                  ],
                )),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

class ImportarProdutosPage extends StatefulWidget {
  const ImportarProdutosPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class ImportarProdutosPageState extends State<ImportarProdutosPage> {
  late Database _database;

  List<dynamic> listaProdutosReq = [];
  List<Map<String, dynamic>> listaProdutosBD = [];

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'my_database.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS produtos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            preco_venda REAL           
          )
        ''');
      },
    );
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse("http://demo7527802.mockable.io/notasAlunos"));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      setState(() {
        listaProdutosReq = jsonResponse;
      });
    } else {
      print("Requisição falhou com o status: ${response.statusCode}.");
    }
  }

  Future<void> salvarProdutosNoBD() async {
    for (var produto in listaProdutosReq) {
      final row = {
        'nome': produto['nome'],
        'preco_venda': produto['preco_venda']
      };
      final id = await _database.insert('produtos', row);
      if (id != null) {
        debugPrint('User created successfully with id: $id');
      } else {
        debugPrint("Failed to create user");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
