import 'dart:typed_data';

class Favorites
{
  int id;
  String name;
  int movie_id;
  Uint8List poster_path;
  Uint8List backdrop_path;
  //String release_date;
  String vote_Count;
  String vote_average;
  String genres;
  String description;
  String popularity;


  Favorites(this.name, this.movie_id , this.poster_path, this.backdrop_path,this.vote_Count, this.vote_average, this.genres , this.description,this.popularity);

  Favorites.map(dynamic obj)
  {
    this.name = obj['name'];
    this.movie_id = obj['movie_id'];
    this.poster_path = obj['poster_path'];
    this.backdrop_path = obj['backdrop_path'];
   // this.release_date = obj['release_date'];
    this.vote_Count = obj['vote_Count'];
    this.vote_average = obj['vote_average'];
    this.genres = obj['genres'];
    this.description = obj['description'];
    this.popularity = obj['popularity'];
  }

  String get _name => name;
  int get _movie_id => movie_id;
  Uint8List get _poster_path => poster_path;
  Uint8List get _backdrop_path => backdrop_path;
 // String get _release_date=> release_date;
  String get _vote_Count => vote_Count;
  String get _vote_average => vote_average;
  String get _genres => genres;
  String get _description => description;
  String get _popularity => popularity;

  Map<String, dynamic> toMap()
  {
    var map = new Map<String,dynamic>();
    map['name'] = name;
    map['movie_id'] = movie_id;
    map['poster_path'] = poster_path;
    map['backdrop_path'] = backdrop_path;
    //map['release_date'] = release_date;
    map['vote_Count'] = vote_Count;
    map['vote_average'] = vote_average;
    map['genres'] = genres;
    map['description'] = description;
    map['popularity'] = popularity;

    return map;
  }

  void setFavoritesId(int id){
    this.id = id;
  }
}