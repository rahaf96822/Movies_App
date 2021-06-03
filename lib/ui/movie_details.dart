import 'package:flutter/material.dart';
import 'package:moviesapp/blocs/trailer_bloc.dart';
import 'package:moviesapp/models/item_model.dart';
import 'package:moviesapp/models/trailer_model.dart';
import 'package:moviesapp/ui/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetails extends StatefulWidget {
  Result data;
  String genres;
  MovieDetails(this.data ,this.genres);
  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

String backdrop_path = "";
class _MovieDetailsState extends State<MovieDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    backdrop_path = widget.data.backdrop_path;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentPage(widget.data , widget.genres),
    );
  }
}

// _launchURL(String _url) async{
//   if (await canLaunch(_url)){
//     await launch(_url);
//   }else {
//     throw 'Could not launch $_url';
//   }
// }

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
              top: 50,
              left: 20,
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              )),
          Positioned(
            top: 50,
            right: 20,
            child: InkWell(
              onTap: (){},
              child: Icon(
                Icons.favorite_border,
                color: Colors.white,
              ),
            )),
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
              style: TextStyle(color: Colors.white ,
                  fontSize: 20 , fontWeight: FontWeight.bold),),
            ),
          ),
          Positioned(
            top: 270,
            left: 20,
            child: GenresItems(widget.genres),
          ),
          Positioned(
            top: 372,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 370,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: _width -40,
                      height: 0.5,
                      color: textColor,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      width: _width,
                      height: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: (_width -40) / 3,
                                height: 120,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(widget.data.popularity.toString(),
                                        style: TextStyle(color: popularityColor ,
                                            fontWeight: FontWeight.bold , fontSize: 24),),
                                      new Text("Popularity" ,style: TextStyle(color: Colors.white),)
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: (_width -40) / 3,
                                height: 120,
                                child:  Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.star , color: iconColor, size: 28,),
                                      RichText(
                                        text: TextSpan(
                                          text: widget.data.vote_average,
                                          style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 20),
                                          children: const <TextSpan>[
                                            TextSpan(text: ' /10', style: TextStyle(color: Colors.white ,fontSize: 14)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: (_width -40) / 3,
                                height: 120,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(widget.data.vote_count.toString(),
                                        style: TextStyle(color: Colors.blue ,
                                            fontWeight: FontWeight.bold , fontSize: 24),),
                                      new Text("Vote Count" ,style: TextStyle(color: Colors.white),)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],),
                    ),
                    Container(
                      width: _width - 40,
                      height: 0.5,
                      color: textColor,
                    ),
                    Container(
                      width: _width - 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SizedBox(height: 16,),
                          new Text("Description",
                            style: TextStyle(color: Colors.white,
                                fontSize: 24 , fontWeight: FontWeight.bold),),
                          SizedBox(height: 8,),
                          new Text(widget.data.overview,
                            style: TextStyle(color: Colors.white,
                                fontSize: 18),),
                          SizedBox(height: 16,),
                          new Text("Trailers",
                            style: TextStyle(color: Colors.white,
                                fontSize: 24 , fontWeight: FontWeight.bold),),
                          SizedBox(height: 16,),
                          PreloadContent(widget.data.id)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// class GetGenres extends StatefulWidget {
//   AsyncSnapshot snapshot;
//   GetGenres(this.snapshot);
//   @override
//   _GetGenresState createState() => _GetGenresState();
// }
//
// class _GetGenresState extends State<GetGenres> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width - 20,
//       child: Wrap(
//         direction: Axis.horizontal,
//         spacing: 8,
//         runSpacing: 8 ,
//         crossAxisAlignment: WrapCrossAlignment.start,
//         children: <Widget>[
//
//         ],
//       ),
//     );
//   }
//
// }

class GenresItems extends StatefulWidget {
  String genres;
  GenresItems(this.genres);
  @override
  _GenresItemsState createState() => _GenresItemsState();
}

class _GenresItemsState extends State<GenresItems> {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: _getGenres(widget.genres),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container();
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return GetGenres(snapshot);
        }
      },
    );
  }

  Widget GenreItem(String genre){
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10 , right: 10 ,top: 5 ,bottom: 5),
        child: new Text(genre,
          style: TextStyle(color: Colors.white),),
      ),
    );
  }

  Future<List<Widget>> _getGenres(String genre) async{
    var values= new List<Widget>();
    var items = genre.split(',');
    for(int i=0; i<items.length ; i++){
      values.add(GenreItem(items[i]));
    }
    await new Future.delayed(new Duration(seconds: 0));
    return values;
  }

  Widget GetGenres(AsyncSnapshot snapshot){
    List<Widget> values = snapshot.data;
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 8,
        runSpacing: 8 ,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: values
      ),
    );
  }
}

class PreloadContent extends StatefulWidget {
  int movieId;
  PreloadContent(this.movieId);
  @override
  _PreloadContentState createState() => _PreloadContentState();
}

class _PreloadContentState extends State<PreloadContent> {
  @override
  Widget build(BuildContext context) {
    bloc_trailer.fetchAllTrailers(widget.movieId);
    return StreamBuilder(
      stream: bloc_trailer.allTrailer,
      builder: (context,AsyncSnapshot<TrailerModel> snapshot){
        if(snapshot.hasData){
          if(snapshot.data.results.length > 0){
            int itmRowCount = (snapshot.data.results.length /2).round();
            double _height = itmRowCount * 155.0;
            return Container(
              width: MediaQuery.of(context).size.width -40,
              height: _height,
              child: TrailerPage(snapshot)
            );
          } else
            return new Text('Not found Trailer',
            style: TextStyle(color: Colors.white),);
        }
        else if(snapshot.hasError){
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator(),);
      },

    );
  }
}

class TrailerPage extends StatefulWidget {
  AsyncSnapshot<TrailerModel> snapshot;
  TrailerPage(this.snapshot);
  @override
  _TrailerPageState createState() => _TrailerPageState();
}

class _TrailerPageState extends State<TrailerPage> {
  _launchURL(String _url) async{
    if (await canLaunch(_url)){
      await launch(_url);
    }else {
      throw 'Could not launch $_url';
    }
  }
  @override
  Widget build(BuildContext context) {
    double itemWidth = (MediaQuery.of(context).size.width -16) /2;
    return new GridView.count(
      padding: EdgeInsets.all(0),
      crossAxisCount: 2,
      childAspectRatio: (itemWidth / 155),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      physics: new NeverScrollableScrollPhysics(),
      children: new List<Widget>.generate(widget.snapshot.data.results.length, (index) {
        return new GridTile(
            child: InkWell(
              onTap: () => _launchURL("https://www.youtube.com/watch?v="+ widget.snapshot.data.results[index].key),
              child: new Container(
                width: MediaQuery.of(context).size.width,
                child: InkWell(
                  onTap: () => _launchURL("https://www.youtube.com/watch?v="+ widget.snapshot.data.results[index].key),
                  child: Wrap(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Stack(
                          children: <Widget>[
                            Image.network(backdrop_path
                              // errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                              //   return Text('Your error widget...');
                              // },
                            ),
                            Container(
                              width: itemWidth,
                              height: 100,
                              color: Colors.black38,
                            ),
                            Positioned(
                              top: 36,
                                left: (itemWidth - 36 - 16) /2,
                                child: Icon(
                                  Icons.play_circle_filled,
                                  size:36 ,
                                ))
                          ],
                        ),
                      ),
                      new Text(
                        widget.snapshot.data.results[index].name,
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ));
      }),
    );
  }
}

