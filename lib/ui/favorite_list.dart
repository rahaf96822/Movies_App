import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviesapp/funcs/fadetranslation.dart';
import 'package:moviesapp/models/favorites.dart';
import 'package:moviesapp/resources/home_presenter.dart';
import 'package:flutter/foundation.dart';
import 'package:moviesapp/ui/colors.dart';
import 'package:moviesapp/ui/favorite_detail.dart';

class FavoriteList extends StatelessWidget {
  List<Favorites> favorites;
  HomePresenter homePresenter;

  FavoriteList(
      List<Favorites> this.favorites ,
      HomePresenter this.homePresenter,{
      Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: favorites == null ? 0 : favorites.length,
      itemBuilder: (BuildContext context , int index){
        return InkWell(
          onTap: (){
            Navigator.push(context, new MyCustomRoute(builder: (context) => new FavoriteDetail(favorites[index])));
          },
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: new ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(
                        favorites[index].poster_path,
                        width: 185,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 20 - 185,
                    height: 300,
                    child: Padding(
                      padding: EdgeInsets.only(top: 30, right: 10,left: 10,bottom: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Text(
                            favorites[index].name,
                            style: TextStyle(color: Colors.white , fontSize: 20),
                          ),
                          // SizedBox(height: 8,),
                          // new Text(
                          //   favorites[index].release_date,
                          //   style: TextStyle(color: Colors.white,fontSize: 16),
                          // ),
                          SizedBox(height: 8,),
                          new Text(favorites[index].genres ,style: TextStyle(fontSize: 16 ,fontWeight: FontWeight.bold, color: textColor)),
                          SizedBox(height: 8,),
                          Row(
                            children: <Widget>[
                              Icon(Icons.star , color: iconColor, size: 28,),
                              RichText(
                                text: TextSpan(
                                  text: favorites[index].vote_average,
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
                    ) ,
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

