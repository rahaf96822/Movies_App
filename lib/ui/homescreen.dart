import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviesapp/blocs/genre_bloc.dart';

import 'package:moviesapp/blocs/movies_bloc.dart';
import 'package:moviesapp/blocs/movies_popular_bloc.dart';
import 'package:moviesapp/models/genre_model.dart';
import 'package:moviesapp/models/item_model.dart';
import 'package:moviesapp/ui/colors.dart';
import 'package:moviesapp/ui/movie_details.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarIconBrightness: Brightness.light
    ));

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: bgColor,
        child: PreloadContent(),
      )
    );
  }
}


class PreloadContent extends StatefulWidget {
  @override
  _PreloadContentState createState() => _PreloadContentState();
}

class _PreloadContentState extends State<PreloadContent> {
  @override
  Widget build(BuildContext context) {
    bloc_genres.fetchAllGenres();
    return StreamBuilder(
      stream: bloc_genres.allGenres,
      builder: (context,AsyncSnapshot<GenreModel> snapshot){
        if(snapshot.hasData){
          return ContentPage(snapshot);
        }
        else if(snapshot.hasError){
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator(),);
      },

    );
  }
}

class ContentPage extends StatefulWidget {
  AsyncSnapshot<GenreModel> snapshotGenres;
  ContentPage(this.snapshotGenres);
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.snapshotGenres);
  }
  @override
  Widget build(BuildContext context) {
    bloc.fetchAllMovies();
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, top: 50),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: bgColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text('Search' ,
                  style: TextStyle(
                      fontFamily: 'Oswald-SemiBold' ,
                      fontWeight: FontWeight.bold,
                      fontSize: 30 ,
                      color: Colors.white),),
                SizedBox(height: 6,),
                TextField(
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24
                  ),
                  decoration: new InputDecoration.collapsed(
                      hintText: 'Movie,Actors,Directors... ',
                    hintStyle: TextStyle(
                      color: textColor,
                      fontSize: 24
                    )
                  ),
                ),
                SizedBox(height: 12,),
                Container(
                  width: MediaQuery.of(context).size.width -40 ,
                height: 0.5, color: textColor,),
                SizedBox(height: 12,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 20,
                  // color: Colors.red,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          child: new Text(
                            'Recent',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22
                            ),
                          )),
                      Positioned(
                        top: 5,
                        right: 20,
                        child: new Text(
                          'SEE ALL',
                          style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                RecentMovies(widget.snapshotGenres),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 20,
                  // color: Colors.red,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          child: new Text(
                            'Popular',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22
                            ),
                          )),
                      Positioned(
                        top: 5,
                        right: 20,
                        child: new Text(
                          'SEE ALL',
                          style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                PopularMovies(widget.snapshotGenres),
              ],
            ),
          )
        )
      ],
    );
    // return StreamBuilder(
    //   stream: bloc.allMovies,
    //   // ignore: missing_return
    //   builder:(context,AsyncSnapshot<ItemModel> snapshot){
    //     if (snapshot.hasData){
    //       return new Container(width: 500, height: 500,color: Colors.yellowAccent,);
    //     }
    //     else
    //     {
    //       print('Something is wrong!');
    //     }
    //    // else Center(child: CircularProgressIndicator(),);
    //   } ,
    // );
  }
}

class RecentMovies extends StatefulWidget {
  AsyncSnapshot<GenreModel> snapshotGenres;
  RecentMovies(this.snapshotGenres);
  @override
  _RecentMoviesState createState() => _RecentMoviesState();
}

class _RecentMoviesState extends State<RecentMovies> {
  @override
  Widget build(BuildContext context) {
    bloc.fetchAllMovies();
    return StreamBuilder(
      stream: bloc.allMovies,
      builder: (context,AsyncSnapshot<ItemModel> snapshot){
        if(snapshot.hasData){
          return Container(
            margin: EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width -20,
            height: 300,
          child: ItemsLoad(snapshot,widget.snapshotGenres),);
        }
        else if(snapshot.hasError){
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator(),);
      },

    );
  }
}

class ItemsLoad extends StatefulWidget {
  AsyncSnapshot<ItemModel> snapshot;
  AsyncSnapshot<GenreModel> snapshotGenres;
  ItemsLoad(this.snapshot , this.snapshotGenres);
  @override
  _ItemsLoadState createState() => _ItemsLoadState();
}

class _ItemsLoadState extends State<ItemsLoad> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.snapshot.data.results.length,
      itemBuilder: (context , int index){
        String genres = widget.snapshotGenres.data.getGenre(widget.snapshot.data.results[index].genre_ids);
        return Row(
          children: <Widget>[
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetails(widget.snapshot.data.results[index],genres),
                  ),
                );
              },
              child: new ConstrainedBox(constraints: new BoxConstraints(
                  minHeight: 300.0,
                  minWidth: MediaQuery.of(context).size.width *0.40,
                  maxHeight: 300.0,
                  maxWidth: MediaQuery.of(context).size.width*0.40
              ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(widget.snapshot.data.results[index].poster_path),
                    ),
                    SizedBox(height: 5,),
                    new Text(widget.snapshot.data.results[index].title,
                      style: TextStyle(color: Colors.white),) ,
                  ],
                ),
              ),
            ),
            SizedBox(width: 20,)
          ],
        );
      },
    );
  }
}

class PopularMovies extends StatefulWidget {
  AsyncSnapshot<GenreModel> snapshotGenres;
  PopularMovies(this.snapshotGenres);
  @override
  _PopularMoviesState createState() => _PopularMoviesState();
}

class _PopularMoviesState extends State<PopularMovies> {

  @override
  Widget build(BuildContext context) {
    bloc_popular.fetchAllPopularMovies();
    return Container(
      width: MediaQuery.of(context).size.width-20,
      height: MediaQuery.of(context).size.height - 500,
      child: StreamBuilder(
        stream: bloc_popular.allPopularMovies,
        builder: (context,AsyncSnapshot<ItemModel> snapshot){
          if(snapshot.hasData){
            return Container(
              width: MediaQuery.of(context).size.width -20,
              height: 300,
              child: ItemsPopularLoad(snapshot , widget.snapshotGenres),);
          }
          else if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator(),);
        },

      )
    );
  }
}

class ItemsPopularLoad extends StatefulWidget {
  AsyncSnapshot<ItemModel> snapshot;
  AsyncSnapshot<GenreModel> snapshotGenres;
  ItemsPopularLoad(this.snapshot , this.snapshotGenres);
  @override
  _ItemsPopularLoadState createState() => _ItemsPopularLoadState();
}

class _ItemsPopularLoadState extends State<ItemsPopularLoad> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(top: 16),
      itemCount: widget.snapshot.data.results.length,
      itemBuilder: (context , int index){
        String genres = widget.snapshotGenres.data.getGenre(widget.snapshot.data.results[index].genre_ids);
        return new Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                  onTap: (){
                  },
                  child: Container(
                    child:  new ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(widget.snapshot.data.results[index].poster_path),
                    ),),
                ),
                Container(
                  width: MediaQuery.of(context).size.width -20 -255,
                  height: 300,
                  child: Padding(
                    padding: EdgeInsets.only(top: 30 , left: 10 ,right: 10 , bottom: 30),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Text(widget.snapshot.data.results[index].title,
                       style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold,color: Colors.white),),
                      SizedBox(height: 8,),
                      new Text(widget.snapshot.data.results[index].release_date,
                        style: TextStyle(fontSize: 16 , color: Colors.white),),
                      SizedBox(height: 8,),
                      new Text(genres ,style: TextStyle(fontSize: 16 ,fontWeight: FontWeight.bold, color: textColor)),
                      SizedBox(height: 8,),
                      Row(
                        children: <Widget>[
                          Icon(Icons.star , color: iconColor, size: 28,),
                          RichText(
                            text: TextSpan(
                              text: widget.snapshot.data.results[index].vote_average,
                              style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 18),
                              children: const <TextSpan>[
                                TextSpan(text: ' /10', style: TextStyle(color: Colors.white ,fontSize: 14)),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),)
              ],
            ),
            SizedBox(height: 4,)
          ],
        );
      },
    );
  }
}