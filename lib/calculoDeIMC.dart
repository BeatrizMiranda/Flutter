import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home()
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _infoText = "Informe seus dados";
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _resetFields(){
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _infoText = "Informe seus dados";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;

      double imc = weight / (height * height);
      String imcFixed = imc.toStringAsPrecision(4);
      
      if(imc < 18.6) {
        _infoText = "Abaixo do peso ($imcFixed)";
      } else if(imc >= 18.6 && imc < 24.9){
        _infoText = "Peso Ideal ($imcFixed)";
      } else if(imc >= 24.9 && imc < 29.9){
        _infoText = "Levemente Acima do Peso ($imcFixed)";
      } else if(imc >= 29.9 && imc < 34.9){
        _infoText = "Obesidade Grau I ($imcFixed)";
      } else if(imc >= 34.9 && imc < 39.9){
        _infoText = "Obesidade Grau II ($imcFixed)";
      } else if(imc >= 40){
        _infoText = "Obesidade Grau III ($imcFixed)";
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh), 
            onPressed: _resetFields
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                child: Icon(Icons.person_outline, size: 120.0, color: Colors.green),
                padding: EdgeInsets.only(top: 10),
              ),
              TextFormField(
                validator: (value) {
                  if(value.isEmpty) {
                    return "Insira um valor";
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Peso (kg)",
                  labelStyle: TextStyle(color: Colors.green)
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25),
                controller: weightController,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20), 
                child: TextFormField(
                  validator: (value) {
                    if(value.isEmpty) {
                      return "Insira um valor";
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Altura (cm)",
                    labelStyle: TextStyle(color: Colors.green)
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 25),
                  controller: heightController,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20), 
                child: Container(
                  height: 50,
                  child: RaisedButton(
                    child: Text("Calcular", style: TextStyle(color: Colors.white, fontSize: 25)),
                    onPressed: () {
                      if(_formKey.currentState.validate()) {
                        _calculate();
                      }
                    },
                    color: Colors.green,
                  ),
              ),
              ),
              Text(_infoText, 
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize:25)
              )
            ],
          ),
        ),
      )
    );
  }
}