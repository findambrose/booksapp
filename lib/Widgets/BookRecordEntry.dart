import 'package:flutter/material.dart';

class BookRecordEntry extends StatelessWidget {
  final String author, year;
  BookRecordEntry({this.author, this.year});
  @override
  Widget build(BuildContext context) {
    return Row(
      //Book name
      mainAxisAlignment: MainAxisAlignment.start,

      children: [
        //Labels
        Column(
          children: [
            Text(
              "Author: ",
               textAlign: TextAlign.start,
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Year: ",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ],
        ),

        SizedBox(width: 10),
        //Values
        Column(
          children: [
            Text(
              author,
              style: TextStyle(color: Colors.orange),
            ),
            SizedBox(height: 10),
            Text(
              year,
              style: TextStyle(color: Colors.orange),
            )
          ],
        ),
      ],
    );
  }
}
