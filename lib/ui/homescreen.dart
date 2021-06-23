import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moviesapp/blocs/genre_bloc.dart';

import 'package:moviesapp/blocs/movies_bloc.dart';
import 'package:moviesapp/blocs/movies_popular_bloc.dart';
import 'package:moviesapp/models/genre_model.dart';
import 'package:moviesapp/models/item_model.dart';
import 'package:moviesapp/services/BackendService.dart';
import 'package:moviesapp/ui/all_recents.dart';
import 'package:moviesapp/ui/colors.dart';

import 'package:moviesapp/ui/favorites_screen.dart';
import 'package:moviesapp/ui/movie_details.dart';
import 'package:moviesapp/ui/all_popular.dart';
import 'package:moviesapp/ui/search_detail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


final TextEditingController _typeAheadController = TextEditingController();
 FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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
      resizeToAvoidBottomInset: false,
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
  void initState() {
    // TODO: implement initState
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
   // showNotification();
    super.initState();
  }

 // Future showNotification() async{
 //    var ScheduledNotificationDateTime = new DateTime.now().add(new Duration(seconds: 10));
 //    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
 //        'your other channel id' ,
 //      'your other channel name',
 //        'your other channel description');
 //   // var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
 //
 //    NotificationDetails platformChannelSpecifics = new NotificationDetails(
 //      android: androidPlatformChannelSpecifics,
 //      //iOS: iOSPlatformChannelSpecifics
 //    );
 //    await flutterLocalNotificationsPlugin.schedule(
 //        0,
 //        'scheduled title',
 //        'scheduled body',
 //        ScheduledNotificationDateTime,
 //        platformChannelSpecifics);
 //  }

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
    //print(widget.snapshotGenres);
    _typeAheadController.clear();
  }
  @override
  Widget build(BuildContext context) {
    _typeAheadController.clear();
    bloc.fetchAllMovies(1);
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
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Search' ,
                        style: TextStyle(
                            fontFamily: 'Oswald-SemiBold' ,
                            fontWeight: FontWeight.bold,
                            fontSize: 30 ,
                            color: Colors.white),),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => new FavoritesScreen()));
                        },
                        child: Icon(
                          Icons.favorite,
                          size: 28,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 6,),
                // TextField(
                //   style: TextStyle(
                //     color: textColor,
                //     fontSize: 24
                //   ),
                //   decoration: new InputDecoration.collapsed(
                //       hintText: 'Movie,Actors,Directors... ',
                //     hintStyle: TextStyle(
                //       color: textColor,
                //       fontSize: 24
                //     )
                //   ),
                // ),
                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _typeAheadController,
                    autofocus: false,
                    style: TextStyle(color: textColor , fontSize: 28),
                    decoration: new InputDecoration.collapsed(
                        hintText: 'Enter movie name ',
                      hintStyle: TextStyle(
                        color: textColor,
                        fontSize: 24
                      )
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    return await BackendService.getSuggestions(pattern);
                  },
                  itemBuilder: (context,suggestion){
                    return ListTile(
                      leading: suggestion.poster_path != null
                      ? Image.network(suggestion.poster_path)
                      : Image.network("https://upload.wikimedia.org/wikipedia/commons/b/b9/No_Cover.jpg"),
                      title: Text(suggestion.title),
                      subtitle: Text("Release date : ${suggestion.release_date}"),
                    );
                  },
                  onSuggestionSelected: (suggestion){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SearchDetail(
                          product : suggestion,
                          genreModel : widget.snapshotGenres.data
                        )));
                  },
                ),
                SizedBox(height: 12,),
                Container(
                  width: MediaQuery.of(context).size.width -40 ,
                height: 0.5, color: textColor,),
                SizedBox(height: 12,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,

                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
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
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                        AllRecents(widget.snapshotGenres)));
                                  },
                                  child: new Text(
                                    'SEE ALL',
                                    style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                                    ),
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
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                        AllPopular(widget.snapshotGenres)));
                                  },
                                  child: new Text(
                                    'SEE ALL',
                                    style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        PopularMovies(widget.snapshotGenres),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        )
      ],
    );
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
    bloc.fetchAllMovies(1);
    return StreamBuilder(
      stream: bloc.allMovies,
      builder: (context,AsyncSnapshot<ItemModel> snapshot){
        if (snapshot.connectionState == ConnectionState.active){
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
        }
        else if(snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator(),);
        else 
          return Container(
            child: Center(
              child: new Text('Something is wrong'),
            ),
          );
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
    bloc_popular.fetchAllPopularMovies(1);
    return Container(
      width: MediaQuery.of(context).size.width-20,
      height: MediaQuery.of(context).size.height - 500,
      child: StreamBuilder(
        stream: bloc_popular.allPopularMovies,
        builder: (context,AsyncSnapshot<ItemModel> snapshot){
         if(snapshot.connectionState == ConnectionState.active){
           if(snapshot.hasData){
             return ItemsPopularLoad(snapshot , widget.snapshotGenres);
           }
           else if(snapshot.hasError){
             return Text(snapshot.error.toString());
           }
           return Center(child: CircularProgressIndicator(),);
         }
         else if(snapshot.connectionState == ConnectionState.waiting)
           return Center(child: CircularProgressIndicator(),);
         else
           return Container(
             child: Center(
               child: new Text('Something is wrong'),
             ),
           );
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
     // physics: NeverScrollableScrollPhysics(),
      //shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(top: 16),
      itemCount: 4,
      //itemCount: widget.snapshot.data.results.length,
      itemBuilder: (context , int index){
        String genres = widget.snapshotGenres.data.getGenre(widget.snapshot.data.results[index].genre_ids);
        return new Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MovieDetails(widget.snapshot.data.results[index], genres)
                    ));
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

// void initializeSetting()async{
//   var initAndroidSet = new AndroidInitializationSettings('app_icon');
//   // var initIosSet = new IOSInitializationSettings();
//   var initset = new InitializationSettings(android: initAndroidSet);
//
//   flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin.initialize(initset);
// }