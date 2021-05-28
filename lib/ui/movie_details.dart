import 'package:flutter/material.dart';
import 'package:moviesapp/models/item_model.dart';
import 'package:moviesapp/ui/colors.dart';

class MovieDetails extends StatefulWidget {
  Result data;
  String genres;
  MovieDetails(this.data ,this.genres);
  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentPage(widget.data , widget.genres),
    );
  }
}


class ContentPage extends StatefulWidget {
  Result data;
  String genres;
  ContentPage(this.data ,this.genres);
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: bgColor,
      child: Stack(
        children: <Widget>[
          new Container(
            height: 360,
            decoration: BoxDecoration(
              image: new DecorationImage(
                fit: BoxFit.fitWidth,
                alignment: FractionalOffset.topCenter,
                image: NetworkImage(
                  widget.data.poster_path.replaceAll("w185", "w400")
                )
              )
            ),
          ),
          Positioned(
            top: 280,
            child: Container(
              padding: EdgeInsets.only(top: 8 , left: 20),
              width: _width,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: [0.1 , 0.3 ,0.5 , 0.7 ,0.9],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  colors: [
                    bgColor.withOpacity(0.01),
                    bgColor.withOpacity(0.25),
                    bgColor.withOpacity(0.6),
                    bgColor.withOpacity(0.9) ,
                  bgColor] ,

                )
              ),
            ),
          ),
          Positioned(
            top: 220,
            left: 20,
            child: Container(
              width: _width -20,
              child: new Text(widget.data.title,
              style: TextStyle(color: Colors.white , fontSize: 20),),
            ),
          ),
          Positioned(
            top: 270,
            left: 20,
            child: GetGenres(widget.genres),
          )
        ],
      ),
    );
  }
}
class GetGenres extends StatefulWidget {
  String genres;
  GetGenres(this.genres);
  @override
  _GetGenresState createState() => _GetGenresState();
}

class _GetGenresState extends State<GetGenres> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 8,
        runSpacing: 8 ,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: <Widget>[
          RowItems(genre),

        ],
      ),
    );
  }

  Widget GenreItem(){
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10 , right: 10 ,top: 5 ,bottom: 5),
        child: new Text("rsac",
          style: TextStyle(color: Colors.white),),
      ),
    );
  }
}

class GenresItems extends StatefulWidget {
  String genres;
  GenresItems(this.genres)
  @override
  _GenresItemsState createState() => _GenresItemsState();
}

class _GenresItemsState extends State<GenresItems> {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: _getGenres(widget.genre),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container();
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createGenres(snapshot);
        }
      },
    );
  }

  // Future<List<Widget>> _getGenres(String genre) async{
  //   var values= new List<Widget>();
  //   var items = genre.split(',');
  //   for(int i=0; i<items.length ; i++){
  //     values.add(GenreItem(items[i]));
  //     if(i != items.length -1){
  //       values.add(SizeBox(
  //           width : 10
  //       ));
  //     }
  //   }
  //   await new Future.
  // }
}

