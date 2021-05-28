class GenreModel
{

  List<Result> results =[];

  GenreModel.fromJson(Map<String,dynamic> parseJson )
  {
    List<Result> temp = [];
    for(var i =0; i< parseJson['genres'].length ; i++){
      Result result = Result(parseJson['genres'][i]);
      temp.add(result);
    }
    temp = temp.toSet().toList();
    results = temp;
  }

  List<Result> get getGenres => results;
  String getGenre(List<int> ids){
    ids = ids.toSet().toList();
    String mygenre = "";
    for(var i =0; i < ids.length ; i++){
      mygenre = results.where((user) => user.id == ids[i]).first.name + ", ";
    }

    mygenre = mygenre.substring(0, mygenre.length -2);
    return mygenre;
  }
}

class Result{
  int id;
  String name;

  Result(result){
    id = result['id'];
    name = result['name'].toString();

  }

  String get get_name => name;
  int get get_id => id;
}