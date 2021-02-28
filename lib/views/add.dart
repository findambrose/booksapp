import 'package:books/BLoC/AddBloc.dart';
import 'package:books/Model/Book.dart';
import 'package:books/Service/AddService.dart';
import 'package:flutter/material.dart';

class Add extends StatelessWidget {
  final _key = GlobalKey<FormState>();

  AddBloc _addBloc = AddBloc(AddService());

  TextEditingController nameController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Data/Books to view
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Book'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<Object>(
            stream: _addBloc.response,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> data = snapshot.data;
                if (data['error'] == true) {
                  SnackBar snackBar = SnackBar(
                    content: Text("Operation failed."),
                     duration: Duration(seconds: 3),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                } else {
                   SnackBar snackBar = SnackBar(
                    content: Text("Book successfully added."),
                    duration: Duration(seconds: 3),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                }
              }

              if (snapshot.hasError){
                SnackBar snackBar = SnackBar(
                    content: Text("Operation failed. Retry."),
                     duration: Duration(seconds: 3),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
              }
              return Form(
                key: _key,
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
                        labelText: 'Book Name',
                        hintText: 'e.g The Power of Habit',
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
                          labelText: 'Book Author',
                          hintText: 'e.g Robert Greene'),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Year published required';
                        }
                      },
                      controller: yearController,
                      decoration: InputDecoration(
                        labelText: 'Year Published',
                        hintText: 'e.g 1974',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          onPressed: () {
                            //Submit record
                            //validate form fields
                            FormState formState = _key.currentState;

                            if (formState.validate()) {
                              print("Form validated");
                              formState.save();
                              Book book = Book(
                                  name: nameController.text,
                                  author: authorController.text,
                                  year: yearController.text);
                              postBook(book);
                            }
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
              );
            }),
      ),
    );
  }

  postBook(Book book) {
    _addBloc.behaviorSubject.sink.add(book);
  }
}
