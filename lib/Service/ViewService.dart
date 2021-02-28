import 'package:books/Helpers/DioHelper.dart';
import 'package:books/Model/Book.dart';

class ViewService {
  ViewService();
  DioHelper dioHelper;
  Future<Map<String, dynamic>> get(String event) async {
    Map<String, dynamic> rResponse;
    dioHelper = DioHelper();
    String url = 'http://localhost:8000/api/books';
    await dioHelper.dio.get(url).then((response) {
      List<Book> books = [];
      for (var item in response.data()) {
        //Create a book object
        Book book = Book(
            name: item['name'], year: item['year'], author: item['author']);
        books.add(book);
      }
      rResponse = {'error': false,
      'books': books 
      };
    }).catchError((e) {
      print('Error caught: ' + e.message);
      rResponse = {'error': true};
    });
    return rResponse;
  }
}
