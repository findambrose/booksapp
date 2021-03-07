
import 'package:books/Service/SearchService.dart';
import 'package:rxdart/rxdart.dart';

import 'Bloc.dart';

class SearchBloc extends Bloc{
BehaviorSubject<String> behaviorSubject = BehaviorSubject();
Stream<Map<String, dynamic>> stream = Stream.empty();

  SearchBloc(SearchService searchService){
      stream = behaviorSubject.distinct().asyncMap(searchService.search).asBroadcastStream();

  }

  @override
  dispose() {

    behaviorSubject.close();
    throw UnimplementedError();
  }


}