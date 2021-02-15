import 'package:flutter/material.dart';
import 'package:udemy_aula/Contatos/home.dart';

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      primaryColor: Colors.red,
    ),
    debugShowCheckedModeBanner: false,
  ));
}
