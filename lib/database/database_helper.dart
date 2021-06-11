import 'package:moviesapp/models/favorite_trailer.dart';
import 'package:moviesapp/models/favorites.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
class DataBaseHelper{
  static final DataBaseHelper _instance = new DataBaseHelper.internal();
  factory DataBaseHelper() => _instance;
  static Database _db;
  
  Future<Database> get db async{
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }
  
  DataBaseHelper.internal();
  
  initDb() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path,"moviefavorites.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }
  
  void _onCreate(Database db, int version) async{
    await db.execute(
      "CREATE TABLE Favorites(id INTEGER PRIMARY KEY,name TEXT, movie_id INT,poster_path BLOB,backdrop_path BLOB,vote_count TEXT ,vote_average TEXT,genres TEXT,description TEXT,popularity TEXT )"
    );

    await db.execute(
      "CREATE TABLE FavoritesTrailer(id INTEGER PRIMARY KEY,movie_id INT,title TEXT,link TEXT)"
    );
  }

  Future<int> insertMovie(Favorites favorite) async{
    var dbClient = await db;

    List<Map> list = await dbClient.rawQuery(
      "SELECT * FROM favorites WHERE movie_id = ?" , [favorite.movie_id]
    );

    int res;
    list.length ==0
      ? {res = await dbClient.insert("Favorites" , favorite.toMap())
    }
    :{};

    return res;
  }


  Future<int> insertMovieTrailer(Trailer favoritetrailer) async{
    var dbClient = await db;
    int res = await dbClient.insert("FavoritesTrailer", favoritetrailer.toMap());
    return res;
  }
  Future<List<Favorites>> getFavorites() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery("SELECT * FROM Favorites ORDER BY id DESC");
    List<Favorites> favorites = new List();
    for (var i=0; i < list.length; i++){
      var favorite = new Favorites(
        list[i]['name'],
    list[i]['movie_id'],
    list[i]['poster_path'],
    list[i]['backdrop_path'],
    //list[i]['release_date'],
    list[i]['vote_count'],
    list[i]['vote_average'],
    list[i]['genres'],
    list[i]['description'],
    list[i]['popularity'],
    );
      favorite.setFavoritesId(list[i]['id']);
      favorites.add(favorite);
    }

    return favorites;
  }

  Future<List<Trailer>> getMovieTrailers(int movie_id) async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery("SELECT * FROM FavoritesTrailer WHERE movie_id = ?", [movie_id]);
    List<Trailer> favorites = new List();
    for (var i=0; i< list.length; i++){
      Trailer d = new Trailer(list[i]['title'], list[i]['link']);
      d.movie_id = movie_id;
      favorites.add(d);
    }

    return favorites;
  }

  Future<int> deleteFavorite(int movie_id) async{
    var dbClient = await db;
    int res = await dbClient.rawDelete("DELETE FROM Favorites WHERE movie_id = ?",[movie_id]);
    return res;
  }

  Future<int> deleteFavoriteTrailer(int movie_id) async{
    var dbClient = await db;
    int res = await dbClient.rawDelete("DELETE FROM FavoritesTrailer WHERE movie_id = ?",[movie_id]);
    return res;
  }

  Future<bool> update(Favorites favorites) async{
    var dbClient = await db;
    int res = await dbClient.update("Favorites" , favorites.toMap(),
    where: "id = ?", whereArgs: <int>[favorites.id]);
    return res > 0 ? true : false;
  }

  Future<bool> isItRecord(int movie_id) async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery("SELECT * FROM Favorites WHERE movie_id= ?" , [movie_id]);
    return list.length > 0 ? true : false;
  }

}