import 'package:flutter/material.dart';
import 'package:moviesapp/blocs/movies_popular_bloc.dart';
import 'package:moviesapp/models/genre_model.dart';
import 'package:moviesapp/models/item_model.dart';
import 'package:moviesapp/ui/colors.dart';
import 'package:moviesapp/ui/movie_details.dart';

int page =1;
class AllPopular extends StatefulWidget {
  AsyncSnapshot<GenreModel> snapshotGenres;
  AllPopular(this.snapshotGenres);
  @override
  _AllPopularState createState() => _AllPopularState();
}

class _AllPopularState extends State<AllPopular> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: HomeScreen(widget.snapshotGenres),
    );
  }
}

class HomeScreen extends StatefulWidget {
  AsyncSnapshot<GenreModel> snapshotGenres;
  HomeScreen(this.snapshotGenres);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20,top: 20),
            width: MediaQuery.of(context).size.width -20,
            height: 60,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 14,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () => {Navigator.pop(context)},
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(width: 10,),
                        new Text("All Populars",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'PTSans-Regular'
                          ),)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width ,
            height: MediaQuery.of(context).size.height -100,
            child: LoadList(widget.snapshotGenres),
          )
        ],
      ),
    );
  }
}

class LoadList extends StatefulWidget {
  AsyncSnapshot<GenreModel> snapshotGenres;
  LoadList(this.snapshotGenres);
  @override
  _LoadListState createState() => _LoadListState();
}

class _LoadListState extends State<LoadList> {
  @override
  Widget build(BuildContext context) {
    bloc_popular.fetchAllPopularMovies(page);
    return StreamBuilder(
      stream: bloc_popular.allPopularMovies,
      builder: (context,AsyncSnapshot<ItemModel> snapshot){
        if(snapshot.hasData){
          return Container(
            width: MediaQuery.of(context).size.width,
            child: InfiniteListExample(snapshot,widget.snapshotGenres),
          );
        }
        else if(snapshot.hasError){
          return Text(snapshot.error.toString());
        }

        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
}


class InfiniteListExample extends StatefulWidget {
  AsyncSnapshot<ItemModel> snapshot;
  AsyncSnapshot<GenreModel> snapshotGenres;
  InfiniteListExample(this.snapshot ,this.snapshotGenres);
  @override
  _InfiniteListExampleState createState() => _InfiniteListExampleState();
}

class _InfiniteListExampleState extends State<InfiniteListExample> {
  List _data =[];
  ScrollController _controller;
  bool isLoad = false , isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    page =1;
    _data = widget.snapshot.data.results;
    _controller = new ScrollController();
    _controller.addListener(() {
      if(_controller.position.pixels == _controller.position.maxScrollExtent &&
          ! _controller.position.outOfRange){
        page++;

        if(page < 501) bloc_popular.fetchAllPopularMovies(page);
        print('${_data.length} data now');
        setState(() {
          isLoad = true;
          isLoading = true;
        });
      }
    });
    _data = widget.snapshot.data.results;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc_popular.allPopularMovies,
        builder: (context , AsyncSnapshot<ItemModel> snapshot){
          if(snapshot.hasData){
            if(snapshot.connectionState == ConnectionState.active){
              List item = _data.where((item) => item.id.toString().
              contains(snapshot.data.results[0].id.toString())).toList();

              if(isLoad && item.length ==0){
                for(var i=0; i<20;i++){
                  _data.add(snapshot.data.results[i]);
                }

                isLoad =false;
                Future.delayed(const Duration(milliseconds: 20),()
                {
                  setState(() {
                    isLoading = false;
                  });
                });
              }

              return Stack(
                children: <Widget>[
                  ListView.builder(
                    padding: EdgeInsets.only(left: 20),
                    controller: _controller,
                    itemBuilder: (context , int index){
                      String genres = widget.snapshotGenres.data.getGenre(_data[index].genre_ids);
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => MovieDetails(_data[index], genres)
                          ));
                        },
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(
                                  child: new ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(widget.snapshot.data.results[index].poster_path,width: 185,),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width -20 - 185,
                                  height: 300,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 30 ,left: 10 ,right: 10 ,bottom: 30
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Text(
                                          _data[index].title,
                                          style: TextStyle(color: Colors.white ,fontSize: 20),
                                        ),
                                        SizedBox(height: 8,),
                                        new Text(
                                          _data[index].release_data,
                                          style: TextStyle(color: Colors.white ,fontSize: 16),
                                        ),
                                        SizedBox(height: 8,),
                                        new Text(
                                          genres,
                                          style: TextStyle(color: textColor ,fontSize: 16),
                                        ),
                                        SizedBox(height: 8,),
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.star , color: iconColor, size: 28,),
                                            RichText(
                                              text: TextSpan(
                                                text: _data[index].vote_average,
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
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 4,)
                          ],
                        ),
                      );
                    },
                    itemCount: _data.length,
                  ),
                  if(!isLoad && isLoading)
                    Center(
                      child: Material(
                        elevation: 16.0,
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: MediaQuery.of(context).size.width -120,
                          height: 120,
                          child: Center(
                            child: Container(
                              width: 260,
                              height: 60,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  SizedBox(height: 3,),
                                  new Text('Movies Loading',
                                    style: TextStyle(color: Colors.white , fontSize: 16),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              );
            }
          } else if (snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator(),);
        }
    );
  }
}