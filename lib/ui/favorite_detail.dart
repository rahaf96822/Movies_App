

import 'package:achievement_view/achievement_view.dart';
import 'package:flutter/material.dart';
import 'package:moviesapp/models/favorite_trailer.dart';
import 'package:moviesapp/models/favorites.dart';


import 'package:moviesapp/resources/home_presenter.dart';
import 'package:moviesapp/ui/colors.dart';
import 'package:moviesapp/ui/movie_details.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoriteDetail extends StatefulWidget {
  Favorites myfavorite;
  FavoriteDetail(this.myfavorite);
  @override
  _FavoriteDetailState createState() => _FavoriteDetailState();
}

class _FavoriteDetailState extends State<FavoriteDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreen(widget.myfavorite ),
    );
  }
}


class HomeScreen extends StatefulWidget {
  Favorites myfavorite;
  HomeScreen(this.myfavorite);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements HomeContract{

  HomePresenter homePresenter;
  bool isItRecord = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homePresenter = new HomePresenter(this);
  }

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
                    image: MemoryImage(
                        widget.myfavorite.poster_path
                    ))
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
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              )),
          Positioned(
              right: 20,
              top: 50,
              child: InkWell(
                onTap: (){
                  setState(() {
                    homePresenter.delete(widget.myfavorite.movie_id);
                    isItRecord = false;
                    AchievementView(context,
                        title: 'Information',
                        subTitle: 'The movie removed to favorites',
                        icon: Icon(
                          Icons.movie,
                          color: Colors.white,
                        ),
                        color: textColor,
                        textStyleTitle: TextStyle(
                            fontFamily: 'PTSans-Regular'
                        ),
                        duration: Duration(seconds: 1),
                        isCircle: true, listener: (status){
                          print(status);
                        }
                    )
                      ..show();
                  });
                },
                child: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
              )),
          Positioned(
            top: 280,
            child: Container(
              padding: EdgeInsets.only(top: 8 , left: 20),
              width: MediaQuery.of(context).size.width,
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
              width: MediaQuery.of(context).size.width -20,
              child: new Text(widget.myfavorite.name,
                style: TextStyle(color: Colors.white ,
                    fontSize: 20 , fontWeight: FontWeight.bold),),
            ),
          ),
          Positioned(
            top: 270,
            left: 20,
            child: GenresItems(widget.myfavorite.genres),
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
                      width: MediaQuery.of(context).size.width -40,
                      height: 0.5,
                      color: textColor,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: (MediaQuery.of(context).size.width -40) / 3,
                                height: 120,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(widget.myfavorite.popularity.toString(),
                                        style: TextStyle(color: popularityColor ,
                                            fontWeight: FontWeight.bold , fontSize: 24),),
                                      new Text("Popularity" ,style: TextStyle(color: Colors.white),)
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: (MediaQuery.of(context).size.width -40) / 3,
                                height: 120,
                                child:  Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.star , color: iconColor, size: 28,),
                                      RichText(
                                        text: TextSpan(
                                          text: widget.myfavorite.vote_average,
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
                                width: (MediaQuery.of(context).size.width -40) / 3,
                                height: 120,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(widget.myfavorite.vote_Count.toString(),
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
                      width: MediaQuery.of(context).size.width - 40,
                      height: 0.5,
                      color: textColor,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SizedBox(height: 16,),
                          new Text("Description",
                            style: TextStyle(color: Colors.white,
                                fontSize: 24 , fontWeight: FontWeight.bold),),
                          SizedBox(height: 8,),
                          new Text(widget.myfavorite.description,
                            style: TextStyle(color: Colors.white,
                                fontSize: 18),),
                          SizedBox(height: 16,),
                          new Text("Trailers",
                            style: TextStyle(color: Colors.white,
                                fontSize: 24 , fontWeight: FontWeight.bold),),
                          SizedBox(height: 16,),
                          FutureBuilder<List<Trailer>>(
                            future: homePresenter.getFavoriteTrailers(widget.myfavorite.movie_id),
                            builder: (context , snapshot){
                              double _height = (snapshot.data.length % 2 == 1 ? (snapshot.data.length /2) +1 : snapshot.data.length/2) + 155.0;
                              if(snapshot.hasError) print(snapshot.error);
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height: _height,
                                child: GridView.count(
                                  padding: EdgeInsets.all(0),
                                  crossAxisCount: 2,
                                  childAspectRatio: (itemWidth / 155),
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  physics: new NeverScrollableScrollPhysics(),
                                  children: new List<Widget>.generate(snapshot.data.length, (index) {
                                    return new GridTile(
                                        child: InkWell(
                                          onTap: () => _launchURL("https://www.youtube.com/watch?v="+ snapshot.data[index].link),
                                          child: new Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: InkWell(
                                              onTap: () => _launchURL("https://www.youtube.com/watch?v="+ snapshot.data[index].link),
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
                                                    snapshot.data[index].title,
                                                    style: TextStyle(color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ));
                                  }),
                                ),
                              );
                            },
                          )
                         // PreloadContent(widget.myfavorite.id)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void screenUpdate() {
    // TODO: implement screenUpdate
  }
}
