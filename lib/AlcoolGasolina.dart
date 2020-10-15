import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _alcoolController = TextEditingController();
  TextEditingController _gasolinaController = TextEditingController();
  String _resultado;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    resetFields();
  }

  void resetFields() {
    _alcoolController.text = '';
    _gasolinaController.text = '';
    setState(() {
      _resultado = 'Informe os dados necessários!';
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildApp(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: buildFormulario(),
      ),
    );
  }

  AppBar buildApp() {
    return AppBar(
      title: Text('Cálculo Álcool/Gasolina'),
      backgroundColor: Colors.blueAccent,
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              resetFields();
            })
      ],
    );
  }

  Form buildFormulario() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildTextFormField(
              label: "Álcool (em Reais)",
              error: "Digite o preço do litro de alcool",
              controller: _alcoolController),
          buildTextFormField(
              label: "Gasolina (em Reais)",
              error: "Digite o preço do litro de gasolina",
              controller: _gasolinaController),
          buildTextResult(),
          buildCalculateButton()
        ],
      ),
    );
  }

  Padding buildCalculateButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.0),
      child: RaisedButton(
          child: Text('Calcular'),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              calculo();
            }
          }),
    );
  }

  String calculo() {
    double alcool = double.parse(_alcoolController.text);
    double gasolina = double.parse(_gasolinaController.text);
    double resultado = alcool / gasolina;

    setState(() {
      _resultado = "Resultado ${resultado.toStringAsPrecision(2)}\n";
      if (resultado < 0.7) {
        _resultado += "Abasteça com álcool!";
      } else if (resultado > 0.7) {
        _resultado += "Abasteça com gasolina!";
      } else if (resultado.isNaN) {
        _resultado = "Digite um valor válido!";
      }
    });
  }

  Padding buildTextResult() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.0),
      child: Text(
        _resultado,
        textAlign: TextAlign.center,
      ),
    );
  }

  TextFormField buildTextFormField(
      {TextEditingController controller, String error, String label}) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      validator: (text) {
        return text.isEmpty ? error : null;
      },
    );
  }
}
