import 'package:flutter/material.dart';

class BookRecordEntry extends StatelessWidget {
String label, value;
BookRecordEntry({this.label, this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      //Book name
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        Text(
         value,
          style: TextStyle(color: Colors.orange),
        )
      ],
    );
  }
}
