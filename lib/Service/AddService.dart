import 'package:books/Helpers/DioHelper.dart';
import 'package:books/Model/Book.dart';

class AddService {
  DioHelper dioHelper;
  Future<Map<String, dynamic>> addBook(Book book) async {
    Map<String, dynamic> reqResponse;
    dioHelper = DioHelper();
    String url = "http://localhost:8000/api/books";

    //Post to remote server
    await dioHelper.dio.post(url, data: book).then((response) {
      print("Post success!!");
      reqResponse = {"response": response.data.toString(),
      "error": false};
    }).catchError((e){
      print("Error Caught: " + e.message);
       reqResponse = {"error": true};
    });
    return reqResponse;
  }

  AddService();
}
