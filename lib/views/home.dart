import 'dart:async';

import 'package:books/BLoC/SearchBloc.dart';
import 'package:books/Model/Book.dart';
import 'package:books/Service/SearchService.dart';
import 'package:books/Widgets/BookRecordEntry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _searchBloc = SearchBloc(SearchService());
  bool _loading = false;

  bool _endSearch = false;

_homeScreen(){
  return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 23),
                  Container(
                    height: MediaQuery.of(context).size.height * .35,
                    width: MediaQuery.of(context).size.height * .8,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.green,
                      hoverElevation: 5,
                      onPressed: () {
                        //move to add screen
                        Navigator.pushNamed(context, '/addBooks');
                        print('Add Books pressed');
                      },
                      child: Text(
                        'Add Review',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black54,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 37),
                  Container(
                    height: MediaQuery.of(context).size.height * .35,
                    width: MediaQuery.of(context).size.height * .8,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hoverElevation: 5,
                      hoverColor: Colors.orangeAccent,
                      color: Colors.orange,
                      onPressed: () {
                        //view all button
                        Navigator.pushNamed(context, '/getBooks');
                        print('Get all Btn Pressed');
                      },
                      child: Text('View Reviews',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black54,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              );
}

  _showError(BuildContext context, String source, var errorMessage) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print(errorMessage);
      SnackBar snackbar = SnackBar(
        content: Text("A $source error occured"),
        duration: Duration(seconds: 3),
      );
      Scaffold.of(context).showSnackBar(snackbar);
      //await Future.delayed(Duration(seconds: 3));
      //Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 8, right: 10),
            width: MediaQuery.of(context).size.width * .7,
            child: TextFormField(
              onChanged: (value) {
                _searchBloc.behaviorSubject.sink.add(value);
                setState(() {
                  _loading = true;
                });
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15),
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Search by Author, Book or Year",
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: _searchBloc.stream,
            builder: (context, snapshot) {
              //error

              if (snapshot.hasError) {
                _showError(context, "general", snapshot.error);
                return Container();
              }

              //loading results
              if (_loading == true && !snapshot.hasData) {
                return 
                  
                  Center(
                    child: SpinKitWanderingCubes(color: Colors.green, size: 60.0),
                  );
              
              }

              //has data state
              if (snapshot.hasData) {
                Map<String, dynamic> data = snapshot.data;
                if (data['error'] == true) {
                  //Show error message
                  _showError(context, 'data', data['errorMessage']);
                 return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 23),
                  Container(
                    height: MediaQuery.of(context).size.height * .35,
                    width: MediaQuery.of(context).size.height * .8,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.green,
                      hoverElevation: 5,
                      onPressed: () {
                        //move to add screen
                        Navigator.pushNamed(context, '/addBooks');
                        print('Add Books pressed');
                      },
                      child: Text(
                        'Add Review',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black54,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 37),
                  Container(
                    height: MediaQuery.of(context).size.height * .35,
                    width: MediaQuery.of(context).size.height * .8,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hoverElevation: 5,
                      hoverColor: Colors.orangeAccent,
                      color: Colors.orange,
                      onPressed: () {
                        //view all button
                        Navigator.pushNamed(context, '/getBooks');
                        print('Get all Btn Pressed');
                      },
                      child: Text('View Reviews',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black54,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              );
                } else {
                  List<Book> books = data['books'];
                    if(books.isEmpty){
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('No reviews found, \nTry a different search term.'),));
                      });
                      return _homeScreen();
                    }

                     //User presses back from search
              if(_endSearch){
                return _homeScreen();
              }
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        //Return a container with a book instance
                        return Container(
                          child: Column(
                            children: [
                              //Title
                              Container(
                                padding: EdgeInsets.all(8),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10))),
                                child: Text(books[index].name.toUpperCase(),
                                    textAlign: TextAlign.center),
                              ),
                              //Content
                              Container(
                                margin: EdgeInsets.only(bottom: 15),
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10))),
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    BookRecordEntry(
                                      author: books[index].author,
                                      year: books[index].year,
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(height: 10),
                                    //Review Section
                                    Column(
                                      children: [
                                        //Review Title
                                        Container(
                                            padding: EdgeInsets.all(8),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                color: Colors.white54,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(10))),
                                            child: Text('Review')),

                                        //Review content
                                        Container(
                                          padding: EdgeInsets.all(7),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10)),
                                              color: Colors.black12),
                                          child: Text(
                                              books[index].review == null
                                                  ? "No review found"
                                                  : books[index].review),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),);
                }
              }
              //default
              return _homeScreen();
            },
          ),
        ),
      ),
    );
  }
  Future<bool> _backPressed() async{
          setState(() {
            _endSearch = true;
         });
         return false;
  }
}
