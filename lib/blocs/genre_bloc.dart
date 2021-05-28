import 'package:moviesapp/models/genre_model.dart';
import 'package:moviesapp/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class GenreBloc{
  final repository = Repository();
  final movieFetcher = PublishSubject<GenreModel>();

  //Observable<ItemModel> get allMovies => movieFetcher.stream;
  Observable<GenreModel> get allGenres => movieFetcher.stream;

  fetchAllGenres() async{
    GenreModel genreModel = await repository.fetchAllGenres();
    movieFetcher.sink.add(genreModel);
  }
  dispose(){
    movieFetcher.close();
  }
}

final bloc_genres = GenreBloc();