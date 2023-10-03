import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


void main() async {
  runApp(MaterialApp(
    home: MyApp(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.amber),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _controller = TextEditingController();
  String stockPrice = "N/A";

  Future<void> fetchStockPrice(String symbol) async {
    final apiKey = 'db79f098Y'; // Substitua pela sua chave API Alpha Vantage
    final url = Uri.parse(
        'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=5min&apikey=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final latestData = data['Time Series (5min)']?.values?.first;
      final price = latestData?['1. open'];

      if (price != null) {
        setState(() {
          stockPrice = price;
        });
      } else {
        setState(() {
          stockPrice = 'N/A';
        });
      }
    } else {
      throw Exception('Falha ao carregar o preço das ações');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Preço das Ações'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Símbolo da Ação'),
              ),
              ElevatedButton(
                onPressed: () {
                  fetchStockPrice(_controller.text.toUpperCase());
                },
                child: Text('Buscar Preço'),
              ),
              SizedBox(height: 20),
              Text(
                'Preço das Ações: $stockPrice',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}