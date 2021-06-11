import 'dart:convert';
import 'package:moviesapp/models/item_model.dart';
import 'package:http/http.dart' as http;

class BackendService{
  static Future<List> getSuggestions(String query) async{
    List<ItemModel> mylist = new List<ItemModel>();

    if(query.length == 0) return null;

    final response = await http.get(
      "https://api.themoviedb.org/3/search/movie?api_key=d8c7aae641b2f4852fdb1908c54eacf5&language=en-US&query="+
        query +
        "&page=1&include_adult=false"
    );

    if(response.statusCode == 200){
      ItemModel mymodel = ItemModel.fromJson(json.decode(response.body), false);
      return mymodel.results;
    }
  }
}