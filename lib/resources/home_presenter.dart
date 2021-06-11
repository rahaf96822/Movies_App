import 'dart:async';
import 'package:moviesapp/database/database_helper.dart';
import 'package:moviesapp/models/favorite_trailer.dart';
import 'package:moviesapp/models/favorites.dart';

abstract class HomeContract{
  void screenUpdate();
}

class HomePresenter
{
  HomeContract _view;
  var db = new DataBaseHelper();
  HomePresenter(this._view);
  delete(int movie_id){
    var db = new DataBaseHelper();
    db.deleteFavorite(movie_id);
    db.deleteFavoriteTrailer(movie_id);
    updateScreen();
  }
  
  Future<List<Favorites>>getFavorites(){
    return db.getFavorites();
  }

  Future<List<Trailer>> getFavoriteTrailers(int movie_id){
    return db.getMovieTrailers(movie_id);
  }
  Future<bool>isItRecord(movie_id){
    return db.isItRecord(movie_id);
  }

  updateScreen(){
    _view.screenUpdate();
  }
}
