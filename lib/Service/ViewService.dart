import 'dart:convert';

import 'package:books/Helpers/DioHelper.dart';
import 'package:books/Helpers/UriHelper.dart';
import 'package:books/Model/Book.dart';

class ViewService {
  ViewService();
  DioHelper _dioHelper;
  Future<Map<String, dynamic>> get(String event) async {
    Map<String, dynamic> rResponse;
    _dioHelper = DioHelper();
    Uri _uri = UriHelper().uri;
    await _dioHelper.dio.getUri(_uri).then((response) {
      List<Book> books = [];
      print(response.data);
      var decoded = jsonDecode(response.data);
      print(decoded[0]);
      print(decoded);
      for (var item in decoded) {
        //Create a book object
        Book book = Book(
            name: item['name'],
            year: item['year'],
            author: item['author'],
            review: item['review']);
        books.add(book);
      }
      rResponse = {'error': false, 'books': books};
    }).catchError((e) {
      print("Error Caught::::::::::: $e");
      rResponse = {'error': true, 'errorMessage': e};
    });
    return rResponse;
  }
}
