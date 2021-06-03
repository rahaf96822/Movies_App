class TrailerModel{
  List<TResult> results = [];
  TrailerModel.fromJson(Map<String, dynamic> parsedJson){
    List<TResult> temp = [];
    for(var i=0; i < parsedJson['results'].length ; i++){
      TResult result = TResult(parsedJson['results'][i]);
      temp.add(result);
    }
    results = temp;
  }
  List<TResult> get getTrailers => results;
}

class TResult{
  String key;
  String name;
  TResult(result){
    key = result['key'].toString();
    name = result['name'].toString();
  }

  String get get_key => key;
  String get get_name => name;
}