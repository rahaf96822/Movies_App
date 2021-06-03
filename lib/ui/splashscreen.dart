import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviesapp/funcs/fadetranslation.dart';
import 'package:moviesapp/ui/colors.dart';
import 'package:moviesapp/ui/homescreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {

  void navigationPage(){
    Navigator.push(context, new MyCustomRoute(builder: (context)=> new HomeScreen()
    ));
  }

  startTime() async{
    var _duration = new Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: bgColor,
      body: new Center(
        child: Image.asset("assets/images/movies.png"),
      ),
    );
  }
}
