import 'dart:convert';

import 'package:books/Helpers/DioHelper.dart';
import 'package:books/Helpers/UriHelper.dart';
import 'package:books/Model/Book.dart';

class SearchService {
  DioHelper dioHelper;
  Future<Map<String, dynamic>> search(String term) async {
    Map<String, dynamic> results;

    dioHelper = DioHelper();
    Uri _uri = UriHelper().uri;
    await dioHelper.dio.getUri(_uri).then((response) {
      List<Book> books = [];
      print(response.data);
      var decoded = jsonDecode(response.data);
      print(decoded[0]);
      print(decoded);
      for (var item in decoded) {
        //Create a book object if item matches search term
        if (item['name'].toString().toLowerCase().contains(term.toLowerCase()) ||
            item['year'].toString().toLowerCase().contains(term.toLowerCase()) ||
            item['author'].toString().toLowerCase().contains(term.toLowerCase())) {
          Book book = Book(
              name: item['name'],
              year: item['year'],
              author: item['author'],
              review: item['review']);
          books.add(book);
        }
      }

      print("Books::: ${books[0].name}");
      results = {'error': false, 'books': books};
    }).catchError((e) {
      print("Error Caught::::::::::: $e");
      
      results = {'error': true, 'errorMessage': e};
    });

    return results;
  }
}
