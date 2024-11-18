import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste de Requisições',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CrudPage(),
    );
  }
}

class CrudPage extends StatefulWidget {
  const CrudPage({super.key});

  @override
  _CrudPageState createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  final TextEditingController idController = TextEditingController(text: "0");
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController categoriaController = TextEditingController();

  List<Map<String, dynamic>> tableData = [];

  @override
  void initState() {
    super.initState();
    _get();
  }

  Future<void> _get() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost/api/testeApi.php/cliente/list"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          tableData = List<Map<String, dynamic>>.from(data);
        });
      } else {
        setState(() {
          tableData = [];
        });
      }
    } catch (e) {
      print("Erro ao executar solicitação GET: $e");
    }
  }

  Future<void> _post() async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost/api/testeApi.php/cliente"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "nome": nomeController.text,
          "categoria": categoriaController.text,
        }),
      );

      final data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(data['message'] ?? 'Erro inesperado'),
      ));
      _get();
    } catch (e) {
      print("Erro ao executar solicitação POST: $e");
    }
  }

  Future<void> _put() async {
    try {
      final response = await http.put(
        Uri.parse(
            "http://localhost/api/testeApi.php/cliente/${idController.text}"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "nome": nomeController.text,
          "categoria": categoriaController.text,
        }),
      );

      final data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(data['message'] ?? 'Erro inesperado'),
      ));
      _get();
    } catch (e) {
      print("Erro ao executar solicitação PUT: $e");
    }
  }

  Future<void> _delete() async {
    try {
      final response = await http.delete(
        Uri.parse(
            "http://localhost/api/testeApi.php/cliente/${idController.text}"),
      );

      final data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(data['message'] ?? 'Erro inesperado'),
      ));
      _get();
    } catch (e) {
      print("Erro ao executar solicitação DELETE: $e");
    }
  }

  void _selectRow(Map<String, dynamic> item) {
    setState(() {
      idController.text = item['id'].toString();
      nomeController.text = item['nome'];
      categoriaController.text = item['categoria'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('C.R.U.D. padrão API'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: 'ID'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: categoriaController,
              decoration: const InputDecoration(labelText: 'Categoria'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: _get, child: const Text('GET')),
                ElevatedButton(onPressed: _post, child: const Text('POST')),
                ElevatedButton(onPressed: _put, child: const Text('PUT')),
                ElevatedButton(onPressed: _delete, child: const Text('DELETE')),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tableData.length,
                itemBuilder: (context, index) {
                  final item = tableData[index];
                  return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text('ID do item: ${item['id']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nome do item: ${item['nome']}'),
                            Text('Categoria do item: ${item['categoria']}')
                          ],
                        ),
                        onTap: () => _selectRow(item),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
