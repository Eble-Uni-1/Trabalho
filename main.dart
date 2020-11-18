import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  //String cidade;
  String pais;
  String cep;
  var temperatura;
  var tempoDescricao;
  var tempoAgora;
  var umidadeAr;
  var vento;
  var rua;
  var complemento;
  var bairro;
  var cidade;

  Future getCEP() async {
    http.Response response =
        await http.get("https://viacep.com.br/ws/$cep/json/");
    var results = jsonDecode(response.body);

    setState(() {
      this.cidade = results['localidade'];
      this.rua = results['logradouro'];
      this.complemento = results['complemento'];
      this.bairro = results['bairro'];
    });
  }

  Future getWeather() async {
    String getCidade = cidade.toString();
    http.Response response = await http.get(
        "http://api.openweathermap.org/data/2.5/weather?q=$getCidade&Brazil&appid=89f3fcb83608b3f5f41204b5972bfae2");
    var results = jsonDecode(response.body);

    setState(() {
      this.temperatura = results['main']['temp'];
      this.tempoDescricao = results['weather'][0]['deon'];
      this.tempoAgora = results['weather'][0]['main'];
      this.umidadeAr = results['main']['humidity'];
      this.vento = results['wind']['speed'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Previsão do tempo'),
          backgroundColor: Colors.blue,
        ),
        body: new SingleChildScrollView(
          child: new Container(
            margin: new EdgeInsets.all(15.0),
            child: new Form(
              key: _key,
              autovalidate: _validate,
              child: _formUI(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formUI() {
    return new Column(
      children: <Widget>[
        // new TextFormField(
        //   decoration: new InputDecoration(hintText: 'Cidade'),
        //   maxLength: 40,
        //   validator: _validarCidade,
        //   onSaved: (String val) {
        //     cidade = val;
        //   },
        // ),
        // new TextFormField(
        //   decoration: new InputDecoration(hintText: 'País'),
        //   maxLength: 40,
        //   validator: _validarPais,
        //   onSaved: (String val) {
        //     pais = val;
        //   },
        // ),
        new TextFormField(
          decoration: new InputDecoration(hintText: 'Digite Seu CEP'),
          maxLength: 8,
          validator: _validaCEP,
          onSaved: (String val) {
            cep = val;
          },
        ),
        new SizedBox(height: 15.0),
        new RaisedButton(
          onPressed: _sendForm,
          child: new Text('Aplicar'),
        ),
        Container(
          color: Colors.red,
          child: Text(
              tempoDescricao.toString() != null
                  ? 'Clima: ' + tempoDescricao.toString()
                  : "",
              style: TextStyle(
                fontSize: 25,
              )),
        ),
        Container(
          color: Colors.red,
          child: Text(
              temperatura.toString().isNotEmpty != null
                  ? 'Temperatura: ' + temperatura.toString()
                  : "",
              style: TextStyle(
                fontSize: 25,
              )),
        ),
        Container(
          color: Colors.red,
          child: Text(
              umidadeAr.toString() != null
                  ? 'Umidade Ar: ' + umidadeAr.toString()
                  : "",
              style: TextStyle(
                fontSize: 25,
              )),
        ),
        Container(
          color: Colors.red,
          child: Text(rua.toString() != null ? 'Rua: ' + rua.toString() : "",
              style: TextStyle(
                fontSize: 25,
              )),
        ),
        Container(
          color: Colors.red,
          child: Text(
              rua.toString() != null
                  ? 'Complemento: ' + complemento.toString()
                  : "",
              style: TextStyle(
                fontSize: 25,
              )),
        ),
        Container(
          color: Colors.red,
          child: Text(
              bairro.toString() != null ? 'Bairro: ' + bairro.toString() : "",
              style: TextStyle(
                fontSize: 25,
              )),
        ),
      ],
    );
  }

  // String _validarCidade(String value) {
  //   String patttern = r'(^[a-zA-Z ]*$)';
  //   RegExp regExp = new RegExp(patttern);
  //   if (value.length == 0) {
  //     return "Informe a cidade";
  //   } else if (!regExp.hasMatch(value)) {
  //     return "A cidade deve apenas caracteres de a-z ou A-Z";
  //   }
  //   return null;
  // }

  //   String _validarPais(String value) {
  //   String patttern = r'(^[a-zA-Z ]*$)';
  //   RegExp regExp = new RegExp(patttern);
  //   if (value.length == 0) {
  //     return "Informe o país";
  //   } else if (!regExp.hasMatch(value)) {
  //     return "O país deve apenas caracteres de a-z ou A-Z";
  //   }
  //   return null;
  // }

  String _validaCEP(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o CEP";
    } else if (!regExp.hasMatch(value)) {
      return "O CEP deve conter apenas números";
    }
    return null;
  }

  _sendForm() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      this.getWeather();
      this.getCEP();
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
