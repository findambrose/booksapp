import 'package:books/BLoC/ViewBloc.dart';
import 'package:books/Model/Book.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.all(10),
            child: StreamBuilder(
                stream: booksStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> data = snapshot.data;
                    if (data['error'] == true) {
                      //Show error message
                      SnackBar snackbar = SnackBar(
                        content:
                            Text('Error fetching books. Pull down to refresh'),
                      );
                      Scaffold.of(context).showSnackBar(snackbar);
                    } else {
                      List<Book> books = data['books'];

                      return ListView.builder(
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            //Return a container with a book instance
                            return Container(
                              child: Column(
                                children: [
                                 BookRecordEntry(label: 'Book Name ', value: books[index].name,),
                                 BookRecordEntry(label: 'Book Author ', value: books[index].author,),
                                 BookRecordEntry(label: 'Year Published', value: books[index].year,),
                                 
                                ],
                              ),
                            );
                          });
                    }
                  }
                  return SpinKitHourGlass(color: Colors.indigo);
                })),
      ),
    );
  }
}
