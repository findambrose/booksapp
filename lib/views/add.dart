import 'package:books/BLoC/AddBloc.dart';
import 'package:books/Model/Book.dart';
import 'package:books/Service/AddService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final _key = GlobalKey<FormState>();
  FocusNode nameNode, authorNode, yearNode, reviewNode; 
  @override
  void initState(){
    super.initState();
    nameNode = FocusNode();
    authorNode = FocusNode();
    yearNode = FocusNode();
    reviewNode = FocusNode();
  }
  bool submitted = false;
  AddBloc _addBloc = AddBloc(AddService());

  TextEditingController nameController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Data/Books to view

    return Scaffold(
      appBar: AppBar(
        title: Text('Review Book'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: StreamBuilder<Object>(
            stream: _addBloc.response,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> data = snapshot.data;
                if (data['error'] == true) {
                  SnackBar snackBar = SnackBar(
                    content: Text("Operation failed. Retry."),
                    duration: Duration(seconds: 3),
                  );

                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    Scaffold.of(context).showSnackBar(snackBar);
                  });
                  return _form();
                } else {
                  SnackBar snackBar = SnackBar(
                    content: Text("Book successfully added."),
                    duration: Duration(seconds: 3),
                  );
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    Scaffold.of(context).showSnackBar(snackBar);
                  });
                  return _form();
                }
              }

              if (snapshot.hasError) {
                print(snapshot.error);
                SnackBar snackBar = SnackBar(
                  content: Text("General error. Retry."),
                  duration: Duration(seconds: 3),
                );
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Scaffold.of(context).showSnackBar(snackBar);
                });
                return _form();
              }

              //submitted state
              if (submitted == true) {
                print("Adding Book......... Please wait.");
                SnackBar snackBar = SnackBar(
                  content: Text("Adding Book......... Please wait."),
                );
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Scaffold.of(context).showSnackBar(snackBar);
                });
                return _form();
              }

              //default
              return _form();
            }),
      ),
    );
  }

  Form _form() {
    return Form(
      key: _key,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
               keyboardType: TextInputType.text,
              autofocus: true,
              focusNode: nameNode,
              onEditingComplete: () => nameNode
              .nextFocus(),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Book name required';
                }
              },
              controller: nameController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Book Name',
                hintText: 'e.g The Power of Habit',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              focusNode: authorNode ,
              onEditingComplete: ()=>authorNode.nextFocus(),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Book author required';
                }
              },
              controller: authorController,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Book Author',
                  hintText: 'e.g Robert Greene'),
            ),
            SizedBox(height: 20),
            TextFormField(
              
              onEditingComplete: ()=>yearNode.nextFocus(),
              focusNode: yearNode,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Year published required';
                }
              },
              controller: yearController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Year Published',
                hintText: 'e.g 1974',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
               keyboardType: TextInputType.text,
              focusNode: reviewNode,
              onFieldSubmitted: (_) => reviewNode.unfocus(),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Review required';
                }
              },
              controller: reviewController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15, top: 50, bottom: 50),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Review',
                hintText: 'e.g An interesting read. Highly recommended.',
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    //Submit record
                    //validate form fields
                    FormState formState = _key.currentState;

                    if (formState.validate()) {
                      //emit true to submitted
                      setState(() {
                        submitted = true;
                      });
                      print("Submitted::: $submitted");
                      print("Form validated");
                      formState.save();
                      Book book = Book(
                          name: nameController.text,
                          author: authorController.text,
                          year: yearController.text,
                          review: reviewController.text);
                      print("Book passed!!!");
                      postBook(book);
                      print('Book posted');
                    }
                  },
                  child: Text('Submit'),
                  color: Colors.green,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/getBooks');
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text('View Submissions'),
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  postBook(Book book) {
    _addBloc.behaviorSubject.sink.add(book);
  }
}
