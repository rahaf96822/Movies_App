import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:moviesapp/models/genre_model.dart';
import 'package:moviesapp/models/item_model.dart';
import 'package:moviesapp/models/trailer_model.dart';

class MovieApiProvider{
  Client client = Client();
  final apikey = "d8c7aae641b2f4852fdb1908c54eacf5";
  final baseUrl = "https://api.themoviedb.org/3/movie";

  Future<ItemModel> fetchMovieList (bool isRecent) async {
    print("entered");
    final response = await client.get("https://api.themoviedb.org/3/movie/now_playing?api_key=$apikey");
    print(response.body.toString());
    if (response.statusCode == 200){
      return ItemModel.fromJson(json.decode(response.body) , isRecent);
    }
    else{
      throw Exception('Failed to load post');
    }
  }

  Future<ItemModel> fetchMoviePopularList (bool isRecent) async {
    print("entered");
    final response = await client.get("https://api.themoviedb.org/3/movie/popular?api_key=$apikey");
    print(response.body.toString());
    if (response.statusCode == 200){
      return ItemModel.fromJson(json.decode(response.body), isRecent);
    }
    else{
      throw Exception('Failed to load post');
    }
  }

  Future<GenreModel> fetchGenresList () async {
    print("entered genres");
    final response = await client.get("https://api.themoviedb.org/3/genre/movie/list?api_key=$apikey");
    print(response.body.toString());
    if (response.statusCode == 200){
      return GenreModel.fromJson(json.decode(response.body),);
    }
    else{
      throw Exception('Failed to load post');
    }
  }

  Future<TrailerModel> fetchTrailers(int movie_id) async {
    print("entered trailer");
    final response = await client.get("https://api.themoviedb.org/3/movie/" + movie_id.toString() +"/videos?api_key=$apikey");
    print(response.body.toString());
    if (response.statusCode == 200){
      return TrailerModel.fromJson(json.decode(response.body),);
    }
    else{
      throw Exception('Failed to load post');
    }
  }
}