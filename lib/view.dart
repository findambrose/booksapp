import 'package:flutter/material.dart';

class View extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: SafeArea(
        child: Container(
          child: Text('Display Books Here')
        ),
      ),
    );
  }
}