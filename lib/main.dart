import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<dynamic> userList = [];

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      setState(() {
        userList = jsonResponse;
      });
    } else {
      print("Requisição falhou com o status: ${response.statusCode}.");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(),
          body: ListView.builder(
            itemCount: userList.length,
            itemBuilder: (BuildContext context, int index) {
              final user = userList[index];
              return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: (index % 2 == 0 ? Colors.blue : Colors.green),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text("Nome: ${user['name']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nome de usuário: ${user['username']}"),
                        Text("Email: ${user['email']}"),
                        Text("Endereço:"),
                        Text("  Rua: ${user['address']['street']}"),
                        Text("  Suite: ${user['address']['suite']}"),
                        Text("  Cidade: ${user['address']['city']}"),
                        Text("  CEP: ${user['address']['zipcode']}"),
                        Text("  Geo:"),
                        Text("    Lat: ${user['address']['geo']['lat']}"),
                        Text("    Lng: ${user['address']['geo']['lng']}"),
                        Text("Telefone: ${user['phone']}"),
                        Text("Website: ${user['website']}"),
                        Text("Empresa:"),
                        Text("  Nome: ${user['company']['name']}"),
                        Text("  Slogan: ${user['company']['catchPhrase']}"),
                        Text("  Área de atuação: ${user['company']['bs']}"),
                      ],
                    ),
                  ));
            },
          )),
    );
  }
}
