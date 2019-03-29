import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=d5f41ca1";

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.teal[100],
      primaryColor: Colors.white,
    ),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final bitcoinController = TextEditingController();
  final pesoController = TextEditingController();
  final libraController = TextEditingController();

  double _dolar;
  double _euro;
  double _bitcoin;
  double _peso;
  double _libra;

  void _realMudaValor(String texto) {
    double real = double.parse(texto);
    dolarController.text = (real / _dolar).toStringAsFixed(2);
    euroController.text = (real / _euro).toStringAsFixed(2);
    bitcoinController.text = (real / _bitcoin).toStringAsFixed(2);
    pesoController.text = (real / _peso).toStringAsFixed(2);
    libraController.text = (real / _libra).toStringAsFixed(2);
  }

  void _dolarMudaValor(String texto) {
    double dolar = double.parse(texto);
    realController.text = (dolar * this._dolar).toStringAsFixed(2);
    euroController.text = (dolar * this._dolar / _euro).toStringAsFixed(2);
    bitcoinController.text =
        (dolar * this._dolar / _bitcoin).toStringAsFixed(2);
    pesoController.text = (dolar * this._dolar / _peso).toStringAsFixed(2);
    libraController.text = (dolar * this._dolar / _libra).toStringAsFixed(2);
  }

  void _euroMudaValor(String texto) {
    double euro = double.parse(texto);
    realController.text = (euro * this._euro).toStringAsFixed(2);
    dolarController.text = (euro * this._euro / _dolar).toStringAsFixed(2);
    bitcoinController.text = (euro * this._euro / _bitcoin).toStringAsFixed(2);
    pesoController.text = (euro * this._euro / _peso).toStringAsFixed(2);
    libraController.text = (euro * this._euro / _libra).toStringAsFixed(2);
  }

  void _bitcoinMudaValor(String texto) {
    double bitcoin = double.parse(texto);
    realController.text = (bitcoin * this._bitcoin).toStringAsFixed(2);
    dolarController.text =
        (bitcoin * this._bitcoin / _dolar).toStringAsFixed(2);
    euroController.text = (bitcoin * this._bitcoin / _euro).toStringAsFixed(2);
    pesoController.text = (bitcoin * this._bitcoin / _peso).toStringAsFixed(2);
    libraController.text =
        (bitcoin * this._bitcoin / _libra).toStringAsFixed(2);
  }

  void _pesoMudaValor(String texto) {
    double peso = double.parse(texto);
    realController.text = (peso * this._peso).toStringAsFixed(2);
    dolarController.text = (peso * this._peso / _dolar).toStringAsFixed(2);
    euroController.text = (peso * this._peso / _euro).toStringAsFixed(2);
    bitcoinController.text = (peso * this._peso / _bitcoin).toStringAsFixed(2);
    libraController.text = (peso * this._peso / _libra).toStringAsFixed(2);
  }

  void _libraMudaValor(String texto) {
    double libra = double.parse(texto);
    realController.text = (libra * this._libra).toStringAsFixed(2);
    dolarController.text = (libra * this._libra / _dolar).toStringAsFixed(2);
    euroController.text = (libra * this._libra / _euro).toStringAsFixed(2);
    bitcoinController.text =
        (libra * this._libra / _bitcoin).toStringAsFixed(2);
    pesoController.text = (libra * this._libra / _peso).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Conversor",
          style: TextStyle(
            color: Colors.teal[900],
          ),
        ),
        backgroundColor: Colors.teal[100],
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando dados!",
                    style: TextStyle(color: Colors.teal[100], fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao carregar dados!",
                      style: TextStyle(color: Colors.teal[100], fontSize: 20.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  _dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  _euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  _bitcoin =
                      snapshot.data["results"]["currencies"]["BTC"]["buy"];
		  _peso = snapshot.data["results"]["currencies"]["ARS"]["buy"];
		  _libra = snapshot.data["results"]["currencies"]["GBP"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 10.0, right: 20.0, left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          color: Colors.teal[100],
                          size: 100.0,
                        ),
                        buildTextField(
                            "Real", "R\$", realController, _realMudaValor),
                        Divider(),
                        buildTextField(
                            "Dollar", "U\$", dolarController, _dolarMudaValor),
                        Divider(),
                        buildTextField(
                            "Euro", "€", euroController, _euroMudaValor),
                        Divider(),
                        buildTextField("Bitcoin", "BTC", bitcoinController,
                            _bitcoinMudaValor),
                        Divider(),
                        buildTextField("Argentine Peso", "\$", pesoController,
                            _pesoMudaValor),
                        Divider(),
                        buildTextField("Pound Sterling(Libra)", "£",
                            libraController, _libraMudaValor),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(String label, String prefix,
    TextEditingController controllerPass, Function functionPass) {
  return TextField(
    controller: controllerPass,
    decoration: InputDecoration(
      labelText: "$label",
      labelStyle: TextStyle(
        color: Colors.teal[100],
      ),
      border: OutlineInputBorder(),
      prefix: Text(
        "$prefix:",
        style: TextStyle(
          color: Colors.teal[100],
        ),
      ),
    ),
    style: TextStyle(
      color: Colors.teal[100],
    ),
    onChanged: functionPass,
    keyboardType: TextInputType.number,
  );
}
