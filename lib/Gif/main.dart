import 'package:flutter/material.dart';
import 'package:udemy_aula/Gif/home.dart';


const request = "https://api.hgbrasil.com/finance?format=json&key=77c1b4fb";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.white,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintStyle: TextStyle(color: Colors.white),
      )
    ),
  ));
}

