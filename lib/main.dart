import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// classe que inicia o aplicativo
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // define Material Design
    return MaterialApp(
      title: 'app',
      initialRoute: "/",
      routes: {
        "/": (context) => const LoginPage(),
        "/listaProdutos": (context) => const LoginPage(),
      },
    );
  }
}

// Classe que instância classe responsável por gerenciar estados
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

// classe que contém os widgets
class LoginPageState extends State<LoginPage> {
  // é necessário um controller para interagir com
  // wigdget de entrada de dados
  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  final String _usuarioEmail = "teste@teste.com";
  final String _usuarioSenha = "senha123";

  // simula envia de informação
  void _enviar() {
    String email = _email.text;
    String senha = _senha.text;
    if (email == _usuarioEmail || senha == _usuarioSenha) {
      Navigator.pushReplacementNamed(context, "/listaProdutos");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        // corpo do aplicativo
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 100.0), // um retângulo para separar widgets
            Image.asset('assets/images/logo.png'),
            const SizedBox(
                height: 300.0), // um retângulo contendo widget de entrada
            SizedBox(
                // label para primeiro número
                width: 300,
                child: TextField(
                  controller: _email, // associa controle ao widget
                  keyboardType: TextInputType.text, // tipo de entrada
                  decoration: const InputDecoration(
                      // customização
                      hintText: 'Login',
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      )),
                )),
            const SizedBox(height: 16.0),
            const SizedBox(
                height: 16.0), // um retângulo contendo widget de entrada
            SizedBox(
                // label para primeiro número
                width: 300,
                child: TextField(
                  controller: _senha, // associa controle ao widget
                  keyboardType: TextInputType.text, // tipo de entrada
                  decoration: const InputDecoration(
                    // customização
                    hintText: 'Senha',
                    prefixIcon: Icon(Icons.account_circle_outlined), //icon
                    enabledBorder: OutlineInputBorder(),
                    //quando receber o foco, altera cor da borda
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                )),
            const SizedBox(height: 16.0),
            // if ternário que controla exibição da resposta.
            // senão foi enviado, então apresenta botões
            // enviar e cancelar
            SizedBox(
                // botões
                width: 300,
                // Row determina que os widgets serão acrescentados
                // lado a lado
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _enviar, // executa _enviar
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

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  ProductsPageState createState() => ProductsPageState();
}

class ProductsPageState extends State<ProductsPage> {
  final List<String> produtos = [
    "Produto 1",
    "Produto 2",
    "Produto 3",
    "Produto 4"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
