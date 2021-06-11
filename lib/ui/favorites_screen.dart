import 'package:flutter/material.dart';
import 'package:moviesapp/models/favorites.dart';
import 'package:moviesapp/resources/home_presenter.dart';
import 'package:moviesapp/ui/colors.dart';
import 'package:moviesapp/ui/favorite_list.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> implements HomeContract{
  HomePresenter homePresenter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homePresenter = new HomePresenter(this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder<List<Favorites>>(
              future: homePresenter.getFavorites(),
              builder: (context, snapshot){
                if(snapshot.hasError) print(snapshot.error);
                var data = snapshot.data;
                return Container(
                  margin: EdgeInsets.only(left: 20 , top: 20),
                  child: snapshot.hasData
                    ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      InkWell(
                        onTap: () => {Navigator.pop(context)},
                        child: Container(
                          margin: EdgeInsets.only(top: 30),
                          width: MediaQuery.of(context).size.width - 20,
                          height: 60,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                top: 14,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    new Text(
                                      'Favorites',
                                      style: TextStyle(fontFamily: 'PTSans-Regular' ,
                                          fontWeight: FontWeight.bold,fontSize: 20 , color: Colors.white),
                                    )
                                  ],
                                )
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        width: MediaQuery.of(context).size.width -20,
                        height: MediaQuery.of(context).size.height - 110,
                        child: new FavoriteList(data,homePresenter),
                      )
                    ],
                  )
              : new Center(
                    child: new CircularProgressIndicator(),
                  )
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void screenUpdate() {
    // TODO: implement screenUpdate
    setState(() {
      
    });
  }
}
