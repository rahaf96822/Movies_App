import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:moviesapp/funcs/fadetranslation.dart';
import 'package:moviesapp/ui/colors.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:moviesapp/ui/homescreen.dart';

class AppIntroScreen extends StatefulWidget {
  @override
  _AppIntroScreenState createState() => _AppIntroScreenState();
}

class _AppIntroScreenState extends State<AppIntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentPage(),
    );
  }
}
int indexPage =0;

class ContentPage extends StatefulWidget {
  @override
  _ContentPageState createState() => _ContentPageState();
}

const titles = ['Offline DataBase' , 'Millions Of Movies', 'Advance Notice'];
const description = ['Create your own favorite list and browse your list without internet.',
  'Get instant access to millions of movies',
  'Let me inform you before the date of vision of the movies in your favorite list.'];

const baseUrl = "assets/images/";
const _images = [
  baseUrl +'data.png',
  baseUrl +'movieicon.png',
  baseUrl+'notification.png'
];

class _ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CarouselSlider(
          onPageChanged: (index){
            setState(() {
              indexPage =index;
            });
          },
          initialPage: 0,
          reverse: false,
          viewportFraction: 1.0,
          height: MediaQuery.of(context).size.height,
          items: [0,1,2].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 300,
                              height: 300,
                              child: Center(
                                child: Image.asset(_images[i],
                                width: 200,
                                color: Colors.white,),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(150),
                                color: bgColor,
                              ),
                            ),
                            SizedBox(height: 30,),
                            new Text(
                              titles[i],
                              textAlign: TextAlign.center,
                              style: TextStyle(color: textColor , fontSize:30,
                                  fontFamily: 'PTSans-Regular',
                                  fontWeight: FontWeight.bold),),
                            SizedBox(height: 30,),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: new Text(
                                description[i],
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: TextStyle(
                                    fontFamily: 'PTSans-Regular',
                                    fontSize: 20,
                                    color: Colors.grey
                                ),
                              ),
                            ),
                            SizedBox(height: 30,),
                            indexPage == 2
                            ? InkWell(
                                onTap: () => Navigator.push(context,
                                    MyCustomRoute(
                                        builder: (context) => new HomeScreen()
                                    )),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: iconColor
                                ),
                                height: 60,
                                margin: EdgeInsets.symmetric(horizontal: 80),
                                child: Center(
                                  child: new Text('GET STARTED',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontFamily: 'PTSans-Regular'
                                    ),),
                                ),
                              )
                            )
                            : SizedBox()
                          ],
                        )
                    )
                );
              },
            );
          }).toList(),
        ),
        Positioned(
          bottom: 20,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: new DotsIndicator(
                dotsCount: 3,
                position: indexPage,
                decorator: DotsDecorator(
                  color: Colors.black38, // Inactive color
                  activeColor: bgColor,
                ),
                //position: 3,
              ),
            ),
          ),
        ),
        Positioned(
          top: 50,
          child: Container(
            height: 20,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Positioned(
                  right: 20,
                  top: 1,
                  child: InkWell(
                    onTap: () => Navigator.push(context,
                        MyCustomRoute(
                          builder: (context) => new HomeScreen()
                        )),
                    child: new Text(
                      'SKIP',
                      style: TextStyle(color: textColor , fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
