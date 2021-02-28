import 'dart:html';

import 'package:books/add.dart';
import 'package:books/home.dart';
import 'package:books/view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context){
          return Home(); 
        },
        '/addBooks': (context){
          return Add(); 
        },
        '/getBooks': (context){
          return View();
        } 
      } ,
    );
  }
}

