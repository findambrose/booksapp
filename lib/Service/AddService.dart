import 'package:books/Helpers/DioHelper.dart';
import 'package:books/Helpers/UriHelper.dart';
import 'package:books/Model/Book.dart';

class AddService {
  DioHelper _dioHelper;
  AddService();
  Future<Map<String, dynamic>> addBook(Book book) async {
    Map<String, dynamic> reqResponse;
    _dioHelper = DioHelper();

    //Post to remote serve
    var data = {'name': book.name, 'author': book.author, 'year': book.year, 'review': book.review};
    Uri _uri = UriHelper().uri;
    print(data);
    await _dioHelper.dio.postUri(_uri, data: data).then((response) {
      print("Post success!!");
      reqResponse = {"response": response.data.toString(), "error": false};
    }).catchError((e) {
      print("Error Caught: " + e);
      reqResponse = {"error": true};
    });
    return reqResponse;
  }
}
