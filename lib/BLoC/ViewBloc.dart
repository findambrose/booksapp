import 'package:books/BLoC/Bloc.dart';
import 'package:books/Model/Book.dart';
import 'package:books/Service/ViewService.dart';
import 'package:rxdart/rxdart.dart';

class ViewBloc implements Bloc{

BehaviorSubject<String> behaviorSubject = BehaviorSubject();
Stream<Map<String, dynamic>> response = Stream.empty();

ViewBloc(ViewService viewService){
  response = behaviorSubject.distinct().asyncMap(viewService.get).asBroadcastStream();
}

  @override
  dispose() {
    // TODO: implement dispose
    behaviorSubject.close();
    throw UnimplementedError();
  }


}