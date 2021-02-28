import 'package:flutter/material.dart';

class Add extends StatelessWidget {
  final key = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Data/Books to view
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: Form(
        key: key,
        child: Column(
          children: [
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Book name required';
                }
              },
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Book Author',
                hintText: 'e.g Robert Greene',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Book author required';
                }
              },
              controller: nameController,
              decoration: InputDecoration(
                  labelText: 'Year Published', hintText: 'e.g 1896'),
            ),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Year published required';
                }
              },
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Book Name',
                hintText: 'e.g The Power of Habit',
              ),
            ),
            Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                  onPressed: () {
                    //Submit record
                  },
                  child: Text('Submit'),
                  color: Colors.green,
                ),
                RaisedButton(
                  onPressed: () {
                    //View All Records
                  },
                  child: Text('View Submissions'),
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
