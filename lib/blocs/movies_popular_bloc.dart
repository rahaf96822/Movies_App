
import 'package:moviesapp/models/item_model.dart';
import 'package:moviesapp/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class MovieBloc{
  final repository = Repository();
  final movieFetcher = PublishSubject<ItemModel>();

  //Observable<ItemModel> get allMovies => movieFetcher.stream;
  Observable<ItemModel> get allPopularMovies => movieFetcher.stream;

  fetchAllPopularMovies() async{
    ItemModel itemModel = await repository.fetchAllPopularMovies();
    movieFetcher.sink.add(itemModel);
  }
  dispose(){
    movieFetcher.close();
  }
}

final bloc_popular = MovieBloc();