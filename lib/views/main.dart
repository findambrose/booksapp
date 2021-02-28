
import 'package:books/views/add.dart';
import 'package:books/views/home.dart';
import 'package:books/views/view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
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

