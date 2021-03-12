import 'package:books/Model/Book.dart';
import 'package:books/Service/AddService.dart';
import 'package:rxdart/rxdart.dart';

class AddBloc{

Stream<Map<String, dynamic>> response = Stream.empty(); 
BehaviorSubject<Book> behaviorSubject = BehaviorSubject();

AddBloc(AddService addService){
  response = behaviorSubject.distinct().asyncMap((addService.addBook)).asBroadcastStream();
}
}