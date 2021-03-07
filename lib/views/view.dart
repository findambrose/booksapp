import 'package:books/BLoC/SearchBloc.dart';
import 'package:books/BLoC/ViewBloc.dart';
import 'package:books/Model/Book.dart';
import 'package:books/Service/SearchService.dart';
import 'package:books/Service/ViewService.dart';
import 'package:books/Widgets/BookRecordEntry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class View extends StatefulWidget {
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  Stream booksStream;

  ViewBloc _viewBloc;
  var _searchBloc = SearchBloc(SearchService());
  bool _loading = false;

  bool _endSearch = false;

  @override
  void didChangeDependencies() {
    setUpData();
    super.didChangeDependencies();
  }

  setUpData() {
    _viewBloc = ViewBloc(ViewService());
    //Emit Event
    _viewBloc.behaviorSubject.sink.add('viewBooksEvent');
    //Populate stream
    booksStream = _viewBloc.response;
  }

  _showError(BuildContext context, String source, var errorMessage) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      print(errorMessage);
      SnackBar snackbar = SnackBar(
        content: Text("A $source error occured"),
        duration: Duration(seconds: 3),
      );
      Scaffold.of(context).showSnackBar(snackbar);
      await Future.delayed(Duration(seconds: 3));
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _backPressed,
          child: Scaffold(
        appBar: AppBar(
          title: Text('Reviews'),
          actions: [
            Container(
              margin: EdgeInsets.only(top: 8, bottom: 8, right: 10),
              width: MediaQuery.of(context).size.width * .5,
              child: TextFormField(
                onChanged: (value) {
                  _searchBloc.behaviorSubject.sink.add(value);
                  setState(() {
                    _loading = true;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 22),
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
                  hintText: "Search All Reviews",
                ),
              ),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setUpData();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(10),
              //Search streambuilder
              child: StreamBuilder(
                stream: _searchBloc.stream,
                builder: (context, snapshot) {
                  //has Data: Search
                  if (snapshot.hasData) {
                    Map<String, dynamic> data = snapshot.data;
                    if (data['error'] == true) {
                      //Show error message
                      _showError(context, 'data', data['errorMessage']);
                      return Container();
                    } else {
                      List<Book> books = data['books'];
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
                                                      color: Colors.white12,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(10),
                                                              topLeft:
                                                                  Radius.circular(
                                                                      10))),
                                                  child: Text('Review')),

                                              //Review content
                                              Container(
                                                padding: EdgeInsets.all(7),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10)),
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
                            }),
                      );
                    }
                  }
                  //General error: Search
                  if (snapshot.hasError) {
                    _showError(context, "general", snapshot.error);
                    return Container();
                  }

                  //loading state: Search

                  if (_loading == true && !snapshot.hasData) {
                    return Center(
                        child: SpinKitPulse(
                      color: Colors.green,
                      size: 70,
                    ));
                  }

                  //default: Search -- Current Screen
                  return StreamBuilder(
                      stream: booksStream,
                      builder: (context, asyncSnapshot) {
                        //has data state
                        print(asyncSnapshot.data);
                        if (asyncSnapshot.hasData) {
                          Map<String, dynamic> data = asyncSnapshot.data;
                          if (data['error'] == true) {
                            //Show error message
                            _showError(context, 'data', data['errorMessage']);
                            return Container();
                          } else {
                            List<Book> books = data['books'];
                            // User presses back from search
                            if (_endSearch) {
                              return _displayResults(books);
                            }
                           return _displayResults(books);
                          }
                        }

                        //has error state
                        if (asyncSnapshot.hasError) {
                          _showError(context, "general", asyncSnapshot.error);
                          return Container();
                        }

                        //loading state
                        return Center(
                            child: SpinKitHourGlass(color: Colors.green));
                      });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _backPressed() async {
    setState(() {
      _endSearch = true;
    });
    // Navigator.pop(context);
    // return false;
  }

  Widget _displayResults(List<Book> books) {
    return ListView.builder(
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
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10))),
                              child: Text('Review')),

                          //Review content
                          Container(
                            padding: EdgeInsets.all(7),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.black12),
                            child: Text(books[index].review == null
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
        });
  }
}
