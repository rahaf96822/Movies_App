
import 'package:moviesapp/models/item_model.dart';
import 'package:moviesapp/resources/repository.dart';
import 'package:moviesapp/ui/all_recents.dart';
import 'package:rxdart/rxdart.dart';

class MovieBloc{
  final repository = Repository();
  final movieFetcher = PublishSubject<ItemModel>();

  //Observable<ItemModel> get allMovies => movieFetcher.stream;
  Observable<ItemModel> get allMovies => movieFetcher.stream;

  fetchAllMovies(int page) async{
    repository.page=page;
    ItemModel itemModel = await repository.fetchAllMovies();
    movieFetcher.sink.add(itemModel);
  }
  dispose(){
    movieFetcher.close();
  }
}

final bloc = MovieBloc();