import 'package:moviesapp/models/genre_model.dart';
import 'package:moviesapp/models/item_model.dart';
import 'package:moviesapp/models/trailer_model.dart';
import 'package:moviesapp/resources/movie_api_provider.dart';

class Repository{
  final movieapiprovider = MovieApiProvider();

  Future<ItemModel> fetchAllMovies() => movieapiprovider.fetchMovieList(true);
  Future<ItemModel> fetchAllPopularMovies() => movieapiprovider.fetchMoviePopularList(false);
  Future<GenreModel> fetchAllGenres() => movieapiprovider.fetchGenresList();
  Future<TrailerModel> fetchTrailers(int movieId) => movieapiprovider.fetchTrailers(movieId);
}