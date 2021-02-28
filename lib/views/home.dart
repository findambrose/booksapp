import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(

        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RaisedButton(
              onPressed: () {
                //move to add screen
                Navigator.pushNamed(context, '/addBooks');
                print('Add Block Btn Emit');
              },
              child: Text('Add Book'),
            ),
            SizedBox(height: 10),
            RaisedButton(
              onPressed: () {
                //view all button
                Navigator.pushNamed(context, '/getBoks');
                print('Get all Btn Pressed');
              },
              child: Text('Get All'),
            )
          ],
        ),
      ),
    );
  }
}
